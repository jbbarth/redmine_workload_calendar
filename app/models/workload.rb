class Workload
  attr_accessor :project, :custom_field_filters, :trackers_filters, :week_from, :week_to

  def initialize(args = {})
    @project = args.delete(:project)
    @custom_field_filters = args.delete(:custom_field_filters)
    @trackers_filters = args.delete(:trackers_filters)
    @week_from = args.delete(:week_from) || Week.today - Workload.display_weeks_before
    @week_to = args.delete(:week_to) || Week.today + Workload.display_weeks_after
  end

  def versions
    @versions ||= Version.where([
      "project_id IN (?) AND effective_date BETWEEN ? AND ?", 
       projects.map{ |p| p.id }, (week_from - 1).first_day, week_to.last_day
    ]).reject do |v|
      v.load_weeks_in_workload(self).blank?
    end.sort_by do |v|
      real_load = v.load_weeks_in_workload(self)
      [v.load_start.year, real_load.first, real_load.length, v.project.name, v.name]
    end
  end

  def issues
    all_issues = Issue.where("project_id IN (?) AND (status_id <> 5 OR closed_on BETWEEN ? AND ?)", projects.map(&:id), week_from.first_day, week_to.last_day)
    if @trackers_filters.present?
      trackers = []
      @trackers_filters.each do |key, tracker|
        t = Tracker.find_by_name(tracker)
        trackers << t if t.present?
      end
      @issues ||= all_issues.where("tracker_id IN (?)", trackers.map(&:id))
    else
      @issues ||= all_issues
    end
  end

  def projects
    if @custom_field_filters && @project
      selected_projects = @project.self_and_descendants.to_a
      @custom_field_filters.each do |key, values|
        if key.to_i > 0
          cf = ProjectCustomField.find(key.to_i)
        else
          cf = ProjectCustomField.find_by_name(key)
        end
        selected_projects.reject!{ |project| !values.include?(project.custom_value_for(cf).value) }  if cf.present? && values.present? #TODO Performances can be improved if this is done with a single SQL query
      end
      selected_projects
    else
      if @project
        @project.self_and_descendants
      else
        Project.all
      end
    end

  end

  def load_by_week
    @load ||= self.versions.inject(Hash.new(0)) do |memo,version|
      version.load_weeks.each do |week|
        memo[week.to_i] += 1
      end
      memo
    end
  end

  def each_week(&block)
    weeks.each do |week|
      yield week
    end
  end

  def weeks
    week_from..week_to
  end
  
  def cache_key(user=User.current)
    return @cache_key if @cache_key
    cache_key ||= "#{@week_from}-#{@week_to}-#{@project ? @project.id : 0}"
    cache_key << versions.map{|v| "#{v.visible?(user) ? "t" : "f"}#{v.id}"}.join("-")
    cache_key << "#{Version.order('updated_on').last.try(:updated_on)}"
    @cache_key = Digest::MD5.hexdigest(cache_key)
  end

  def cache_key_by_issues(user=User.current)
    return @cache_key if @cache_key
    cache_key ||= "#{@week_from}-#{@week_to}-#{@project ? @project.id : 0}"
    cache_key << issues.map{|i| "#{i.id}"}.join("-")
    cache_key << "#{Issue.order('updated_on').last.try(:updated_on)}"
    @cache_key = Digest::MD5.hexdigest(cache_key)
  end

  class << self
    def display_weeks_before
      n = Setting.plugin_redmine_workload_calendar["display_weeks_before"]
      n.scan(/\d+/).first.to_s.to_i
    end

    def display_weeks_after
      n = Setting.plugin_redmine_workload_calendar["display_weeks_after"]
      n.scan(/\d+/).first.to_s.to_i
    end
  end
end

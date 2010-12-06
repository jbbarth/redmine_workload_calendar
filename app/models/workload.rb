class Workload
  attr_accessor :project, :week_from, :date_from, :week_to, :date_to
  
  def initialize(args = {})
    @project = args.delete(:project)
    @week_from = args.delete(:week_from) || Week.new(Date.today) - display_weeks_before
    @date_from = @week_from.first_day
    @week_to = args.delete(:week_to) || Week.new(Date.today) + display_weeks_after
    @date_to = @week_to.last_day
  end
  
  def versions
    @versions ||= Version.all(:conditions => [
      "project_id IN (?) AND effective_date BETWEEN ? AND ?", 
       projects, date_from - 7, date_to + 7
    ]).reject do |v|
      v.load_weeks_in_workload(self).blank?
    end.sort_by do |v|
      real_load = v.load_weeks_in_workload(self)
      [v.load_start.year, real_load.first, real_load.length, v.project.name, v.name]
    end
  end
  
  def projects
    if @project
      @project.self_and_descendants
    else
      Project.all
    end
  end
  
  def load_by_week
    @load ||= self.versions.inject(Hash.new(0)) do |memo,version|
      version.load_weeks.each do |week|
        memo[week] += 1
      end
      memo
    end
  end
  
  def each_monday(&block)
    (date_from..date_to).select do |d|
      d.cwday == 1 #mondays only
    end.map do |d|
      [d.year, d.cweek]
    end.each do |d|
      yield Date.commercial(d[0],d[1],1)
    end
  end
  
  def display_weeks_before
    n = Setting["plugin_redmine_workload_calendar"]["display_weeks_before"] rescue ""
    n.scan(/\d+/).to_s.to_i
  end
  
  def display_weeks_after
    n = Setting["plugin_redmine_workload_calendar"]["display_weeks_after"] rescue ""
    n.scan(/\d+/).to_s.to_i
  end
  
  def weeks
    (date_from..date_to).map(&:cweek).uniq
  end
  
  def cache_key(user=User.current)
    return @cache_key if @cache_key
    cache_key ||= "#{@date_from}-#{@date_to}-#{@project ? @project.id : 0}"
    cache_key << versions.map{|v| "#{v.visible?(user) ? "t" : "f"}#{v.id}"}.join("-")
    cache_key << "#{Version.last(:order => 'updated_on').try(:updated_on)}"
    @cache_key = Digest::MD5.hexdigest(cache_key)
  end
end

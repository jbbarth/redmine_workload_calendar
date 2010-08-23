class Workload
  attr_accessor :project, :date_from, :date_to
  
  def initialize(args = {})
    @project = args.delete(:project)
    @date_from = args.delete(:date_from) || Date.today - (7 * display_weeks_before)
    @date_to = args.delete(:date_to) || Date.today + (7 * display_weeks_after)
  end
  
  def versions
    @versions ||= Version.all(:conditions => [
      "project_id IN (?) AND effective_date BETWEEN ? AND ?", 
       projects, date_from, date_to
    ]).sort_by{|v| v.load_start}
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
    (date_from..date_to).each do |d|
      yield d if d.wday == 1
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
end

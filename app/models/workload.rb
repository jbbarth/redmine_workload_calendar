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
       projects, date_from - 7, date_to + 7
    ]).sort_by{|v| [v.load_start, v.project.name, v.name] }
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
    (date_from..date_to).map do |d|
      [d.year, d.cweek]
    end.uniq.each do |d|
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
end

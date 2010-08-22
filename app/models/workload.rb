class Workload
  def initialize(args = {})
    @project = args.delete(:project)
  end
  
  def versions
    @versions ||= Version.all(:conditions => [
      "project_id IN (?) AND effective_date BETWEEN ? AND ?", 
       projects, Workload.date_from, Workload.date_to
    ])
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
      memo[version.effective_date.cweek] += 1
      memo
    end
  end
  
  def self.date_from
    Date.today - 30
  end
  
  def self.date_to
    Date.today + 120
  end
  
  def self.each_monday(&block)
    (date_from..date_to).each do |d|
      yield d if d.wday == 1
    end
  end
end

class Workload
  def initialize(args = {})
    @project = args.delete(:project)
  end
  
  def versions
    @versions ||= Version.all(:conditions => [
      "project_id IN (?) AND effective_date BETWEEN ? AND ?", 
       projects, date_from, date_to
    ])
  end
  
  def projects
    if @project
      @project.self_and_descendants
    else
      Project.all
    end
  end
  
  def date_from
    Date.today - 3000
  end
  
  def date_to
    Date.today + 150
  end
end

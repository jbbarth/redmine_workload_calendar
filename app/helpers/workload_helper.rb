module WorkloadHelper
  def workload_versions
    Version.all(:conditions => [
      "project_id IN (?) AND effective_date BETWEEN ? AND ?", 
       workload_projects, date_from, date_to
    ])
  end
  
  def workload_projects
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

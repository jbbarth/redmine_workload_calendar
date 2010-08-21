module WorkloadHelper
  def workload_css_classes_for(version,day)
    c = []
    c << "selected" if day.cweek == version.effective_date.cweek
    c << "today" if day.cweek == Date.today.cweek
    c.join(" ")
  end
  
  def link_to_workload_version(version)
    link_to_if version.visible?, truncate("#{version.project} - #{version}", :length => 30),
               { :controller => 'versions', :action => 'show', :id => version }
  end
end

module WorkloadHelper
  def workload_html_options_for(version,day,workload_weeks)
    options = {}
    #css classes
    c = []
    c << "selected" if version.load_weeks.include?(day.cweek)
    c << "today" if day.cweek == Date.today.cweek
    options[:class] = c.join(" ")
    #colspan
    if c.include?("selected")
      options[:colspan] = version.load_weeks.reject{|e|!workload_weeks.include?(e)}.length
    end
    options
  end
  
  def workload_week_style(load_by_week,day)
    l = load_by_week[day.cweek]
    #TODO: remove this hard-coded limit
    l = 4 if l >= 4
    "load-#{l}"
  end
  
  def link_to_workload_version(version)
    link_to_if version.visible?, truncate("#{version.project} - #{version}", :length => 40),
               { :controller => 'versions', :action => 'show', :id => version }
  end
end

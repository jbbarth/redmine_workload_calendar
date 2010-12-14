module WorkloadHelper
  def workload_html_options_for(version,week,workload)
    options = {}
    #css classes
    c = []
    c << "selected" if version.load_weeks.include?(week)
    c << "today" if week == Week.today
    options[:class] = c.join(" ") unless c.blank?
    #colspan
    if c.include?("selected")
      options[:colspan] = version.load_weeks_in_workload(workload).length
    end
    options
  end
  
  def workload_week_style(load_by_week,week)
    l = load_by_week[week.to_i]
    #TODO: remove this hard-coded limit
    l = 3 if l > 3
    "load-#{l}"
  end
  
  def link_to_workload_version(version)
    link_to_if version.visible?, truncate("#{version.project} - #{version}", :length => 40),
               { :controller => 'versions', :action => 'show', :id => version }
  end
  
  def workload_version_tooltip(version)
    h = '&nbsp;'
    h << '<span class="tip workload-version-tooltip">'
    [[l(:field_due_date), format_date(version.effective_date)],
     [l(:field_version_load), version.version_load.name],
     [l(:field_description), version.description ]].each do |a|
      h << "<p><strong>#{a[0]}</strong>: #{h a[1]}</p>"
    end
    h << '</span>'
  end
end

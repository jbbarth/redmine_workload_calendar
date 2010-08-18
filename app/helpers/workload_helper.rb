module WorkloadHelper
  def workload_css_classes_for(version,day)
    c = []
    c << "selected" if day.cweek == version.effective_date.cweek
    c << "today" if day.cweek == Date.today.cweek
    c.join(" ")
  end
end

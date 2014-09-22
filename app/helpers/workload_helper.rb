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
    if Setting.plugin_redmine_workload_calendar["show_workload"]
      l = load_by_week[week.to_i]
      #TODO: remove this hard-coded limit
      l = 3 if l > 3
      "load-#{l}"
    else
      "no-load"
    end
  end
  
  def link_to_workload_version(version, title=version.name)
    link_to_if version.visible?, title, { :controller => 'versions', :action => 'show', :id => version }
  end

  def link_to_workload_issue(issue, title=issue.subject)
    link_to_if issue.visible?, title, { :controller => 'issues', :action => 'show', :id => issue }
  end
  
  def workload_version_tooltip(version)
    h = ''
    h << '<span class="tip workload-version-tooltip">'
    [[l(:field_version), version.name],
     [l(:field_due_date), format_date(version.effective_date)],
     [l(:field_version_load), version.version_load.try(:name)],
     [l(:field_description), version.description ]].each do |a|
      h << "<p><strong>#{a[0]}</strong>: #{h a[1]}</p>"
    end
    h << '</span>'
    h.html_safe
  end

  def workload_issue_tooltip(issue)
    h = ''
    h << '<span class="tip workload-issue-tooltip">'
    [[l(:field_issue), issue.subject],
     [l(:field_due_date), format_date(issue.due_date)]].each do |a|
      h << "<p><strong>#{a[0]}</strong>: #{h a[1]}</p>"
    end
    h << '</span>'
    h.html_safe
  end

  def render_workload(action, week, workload)
    css = "tooltip working"
    css << " begun" if action.load_start_visible?(workload)
    css << " ended" if action.load_end_visible?(workload)
    content_tag :td, workload_html_options_for(action, week, workload) do
      content_tag :div, :class => css do
        case action
          when Version
            workload_version_tooltip(action) + content_tag(:div, content_tag(:span, link_to_workload_version(action)), :class => "load-per-line")
          when Issue
            workload_issue_tooltip(action) + content_tag(:div, content_tag(:span, link_to_workload_issue(action)), :class => "load-per-line")
        end
      end
    end
  end
end

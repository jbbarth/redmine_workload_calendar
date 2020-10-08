Redmine::WikiFormatting::Macros.register do
  desc "Display a workload calendar.\n\n" +
       "With no argument, only current project and descendants versions are listed.\n" +
       "On cross-project pages (such as welcome page), all projects versions are listed.\n" +
       "You can provide an ID or project identifier to list only versions of this project and descendants.\n\n" +
       "Example:\n" +
       "  !{{workload}} -- display versions of current project (or all if you're not under a project)\n" +
       "  !{{workload(myapplication)}} -- display versions of project 'myapplication'\n" +
       "  !{{workload(2)}} -- display versions of project 2\n" +
       "  !{{workload(myapplication, {:my_custom_field1=>valueA valueB valueC, :my_custom_field2=>value1 value2 value3} )}} -- display versions of project 'myapplication' and descendants if there custom fields have one of the given values\n" +
       "  !{{workload_by_issues(myapplication, {:trackers=>tracker_id_1 id_2 id_3} )}} -- display project 'myapplication' and descendants where at least one issue has one of the given trackers"

  macro :workload do |obj, args|
    args, options = extract_macro_options(args, :parent)
    project = Project.find(args.first) rescue nil
    #TODO: remove this ugly thing
    custom_field_filters = args.second.gsub(/[{}:]/,'').split(', ').map{|h| h1,h2 = h.split('=>'); {h1 => h2.split(' ')}}.reduce(:merge) if args.second.present? rescue nil
    # Only work with custom fields and custom values without spaces #TODO improve it
    custom_field_filters = nil unless custom_field_filters.is_a?(Hash)
    ActionView::Base.send(:include, WorkloadHelper)
    ActionView::Base.send(:include, ProjectsHelper)
    ActionView::Base.send(:include, ApplicationHelper) # Tests won't pass without that
    render :partial => 'projects/workload',
           :locals => {:project => project, :custom_field_filters => custom_field_filters}
  end

  macro :workload_by_issues do |obj, args|
    args, options = extract_macro_options(args, :parent)
    project = Project.find(args.first) rescue nil
    #TODO: remove this ugly thing
    trackers_filters = args.second.gsub(/[{}:]/,'').split(', ').map{|h| h1,h2 = h.split('=>'); {h1 => h2.split(' ')}}.reduce(:merge) if args.second.present? rescue nil
    trackers_filters = nil unless trackers_filters.is_a?(Hash)
    ActionView::Base.send(:include, WorkloadHelper)
    ActionView::Base.send(:include, ProjectsHelper)
    ActionView::Base.send(:include, ApplicationHelper) # Tests won't pass without that
    render :partial => 'projects/workload_by_issues',
           :locals => {:project => project, :trackers_filters => trackers_filters}
  end
end

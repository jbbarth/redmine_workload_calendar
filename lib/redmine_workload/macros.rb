Redmine::WikiFormatting::Macros.register do
  desc "Display a workload calendar.\n\n" +
       "With no argument, only current project and descendants versions are listed.\n" +
       "On cross-project pages (such as welcome page), all projects versions are listed.\n" +
       "You can provide an ID or project identifier to list only versions of this project and descendants.\n\n" +
       "Example:\n" +
       "  !{{workload}} -- display versions of current project (or all if you're not under a project)\n" +
       "  !{{workload(myapplication)}} -- display versions of project 'myapplication'\n" +
       "  !{{workload(2)}} -- display versions of project 2'\n" +
       "  !{{workload(myapplication, {:my_custom_field1=>valueA valueB valueC, :my_custom_field2=>value1 value2 value3} )}} -- display versions of project 'myapplication' and descendants if there custom fields have one of the given values"

  macro :workload do |obj, args|
    args, options = extract_macro_options(args, :parent)
    project = Project.find(args.first) rescue nil
    #TODO: remove this ugly thing
    custom_field_filters = args.second.gsub(/[{}:]/,'').split(', ').map{|h| h1,h2 = h.split('=>'); {h1 => h2.split(' ')}}.reduce(:merge) if args.second.present?
    ActionView::Base.send(:include, WorkloadHelper)
    ActionView::Base.send(:include, ProjectsHelper)
    render :partial => 'projects/workload',
           :locals => {:project => project, :custom_field_filters => custom_field_filters}
  end
end

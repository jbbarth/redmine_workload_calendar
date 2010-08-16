Redmine::WikiFormatting::Macros.register do
  desc "Display a workload calendar."

  macro :workload do |obj, args|
    args, options = extract_macro_options(args, :parent)
    #return "Error: you should provide an ID" if args.size == 0
    #TODO: remove this ugly thing
    ActionView::Base.send(:include, WorkloadHelper)
    ActionView::Base.send(:include, ProjectsHelper)
    render :partial => 'projects/workload'
  end
end

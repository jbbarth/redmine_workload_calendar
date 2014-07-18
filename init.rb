require 'redmine'

ActionDispatch::Callbacks.to_prepare do
  # Don't lose our macros on reload
  require_dependency 'redmine_workload/macros'
  # Patches to existing classes/modules
  require_dependency 'redmine_workload/patches/version_patch'
  require_dependency 'redmine_workload/patches/issue_patch'
end

Redmine::Plugin.register :redmine_workload_calendar do
  name 'Redmine Workload Calendar plugin'
  description 'Add ability to display a workload calendar'
  url 'https://github.com/jbbarth/redmine_workload_calendar'
  author 'Jean-Baptiste BARTH'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
  version '0.1'
  requires_redmine :version_or_higher => '2.0.3'
  settings :partial => 'settings/workload_settings',
           :default => {
             'display_weeks_before' => "4",
             'display_weeks_after'  => "16"
           }
end

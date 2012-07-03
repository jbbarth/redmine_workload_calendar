require 'redmine'
require 'redmine_workload/macros'

# Patches to existing classes/modules
ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_workload/patches/version_patch'
end

Redmine::Plugin.register :redmine_workload_calendar do
  name 'Redmine Workload Calendar plugin'
  author 'Jean-Baptiste BARTH'
  description 'Add ability to display a workload calendar'
  url 'http://github.com/jbbarth/redmine_workload_calendar'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
  version '0.1'
  requires_redmine :version_or_higher => '2.0.3'
  settings :partial => 'settings/workload_settings',
           :default => {
             'display_weeks_before' => "4",
             'display_weeks_after'  => "16"
           }
end

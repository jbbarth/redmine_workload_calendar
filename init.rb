require 'redmine'

Redmine::Plugin.register :redmine_workload_calendar do
  name 'Redmine Workload Calendar plugin'
  author 'Jean-Baptiste BARTH'
  description 'Add ability to display a workload calendar'
  url 'http://github.com/jbbarth/redmine_workload_calendar'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
  version '0.1'
  requires_redmine :version_or_higher => '1.0.0'
end

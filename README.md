# Redmine workload calendar plugin

This plugin aims at providing a workload calendar depending on versions. Calendar is simple as this 
plugin should be considered as a communication tool for teams with many projects managed in Redmine.


## How to use it

    {{workload}} -- display versions of current project (or all if you're not under a project)
    {{workload(project_identifier)}} -- display versions of project and descendants
    {{workload(2)}} -- display versions of project 2
    {{workload(project_identifier, {:my_custom_field1=>valueA valueB valueC, :my_custom_field2=>value1 value2 value3} )}} -- display versions of project and descendants if there custom fields have one of the given values
    
    {{workload_by_issues(project_identifier, {:trackers=>valueA valueB valueC} )}} -- display project and descendants where at least one issue has one of the given trackers


## Dependency

Note that this plugin now depends on:
* **redmine_base_deface** which can be found [here](https://github.com/jbbarth/redmine_base_deface)

## Test status

|Plugin branch| Redmine Version   | Test Status       |
|-------------|-------------------|-------------------|
|master       | master            | [![Build1][1]][5] |  
|master       | 4.1.0             | [![Build1][2]][5] |  
|master       | 4.0.6             | [![Build2][3]][5] |

[1]: https://travis-matrix-badges.herokuapp.com/repos/jbbarth/redmine_workload_calendar/branches/master/1
[2]: https://travis-matrix-badges.herokuapp.com/repos/jbbarth/redmine_workload_calendar/branches/master/2
[3]: https://travis-matrix-badges.herokuapp.com/repos/jbbarth/redmine_workload_calendar/branches/master/3
[5]: https://travis-ci.com/jbbarth/redmine_workload_calendar

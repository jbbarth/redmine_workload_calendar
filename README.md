# Redmine workload calendar plugin

This plugin aims at providing a workload calendar depending on versions. Calendar is simple as this 
plugin should be considered as a communication tool for teams with many projects managed in Redmine.


## How to use it

    {{workload}} -- display versions of current project (or all if you're not under a project)
    {{workload(project_identifier)}} -- display versions of project and descendants
    {{workload(2)}} -- display versions of project 2
    {{workload(project_identifier, {:my_custom_field1=>valueA valueB valueC, :my_custom_field2=>value1 value2 value3} )}} -- display versions of project and descendants if there custom fields have one of the given values
    
    {{workload_by_issues(project_identifier, {:trackers=>tracke_id_1 id_2 id_3} )}} -- display project and descendants where at least one issue has one of the given trackers


## Dependency

Note that this plugin now depends on:
* **redmine_base_deface** which can be found [here](https://github.com/jbbarth/redmine_base_deface)

## Test status

|Plugin branch| Redmine Version   | Test Status      |
|-------------|-------------------|------------------|
|master       | 4.2.0             | [![4.2.0][1]][5] |  
|master       | 4.1.2             | [![4.1.2][2]][5] |  
|master       | 4.0.8             | [![4.0.8][3]][5] |
|master       | master            | [![master][4]][5]|

[1]: https://github.com/jbbarth/redmine_workload_calendar/actions/workflows/4_2_0.yml/badge.svg
[2]: https://github.com/jbbarth/redmine_workload_calendar/actions/workflows/4_1_2.yml/badge.svg
[3]: https://github.com/jbbarth/redmine_workload_calendar/actions/workflows/4_0_8.yml/badge.svg
[4]: https://github.com/jbbarth/redmine_workload_calendar/actions/workflows/master.yml/badge.svg
[5]: https://github.com/jbbarth/redmine_workload_calendar/actions

# Redmine workload calendar plugin

This plugin aims at providing a workload calendar depending on versions. Calendar is simple as this 
plugin should be considered as a communication tool for teams with many projects managed in Redmine.


## How to use it

    {{workload}} -- display versions of current project (or all if you're not under a project)
    {{workload(project_identifier)}} -- display versions of project and descendants
    {{workload(2)}} -- display versions of project 2
    {{workload(project_identifier, {:my_custom_field1=>valueA valueB valueC, :my_custom_field2=>value1 value2 value3} )}} -- display versions of project and descendants if there custom fields have one of the given values
    
    {{workload_by_issues(project_identifier, {:trackers=>valueA valueB valueC} )}} -- display project and descendants where at least one issue has one of the given trackers

require File.dirname(__FILE__) + '/../test_helper'
require 'redmine_workload/macros'

class RedmineWorkload::MacrosTest < ActionView::TestCase
  include ApplicationHelper
  include ERB::Util

  fixtures :projects, :custom_fields, :custom_values

  setup do
    @project = Project.create!(:name => "Project X", :identifier => "project-x")
    @custom_field = ProjectCustomField.create!(:name => 'newCustomField', :field_format=>'list', :possible_values=>['Environment', 'testValue'])
    @custom_value = CustomValue.create!(customized_type:'Project', customized_id:@project.id, custom_field_id: @custom_field.id, value: "testValue")
    Version.create!(:name=>"Dumb version 1", :project_id => @project.id, :version_load_id => 2, :effective_date => Date.today)
    Version.create!(:name=>"Dumb version 2", :project_id => @project.id, :version_load_id => 3, :effective_date => Date.today+1.day)
    Version.create!(:name=>"Dumb version 3", :project_id => @project.id, :version_load_id => 3, :effective_date => Date.today+15.days)
  end

  test "workload macro" do
    assert textilizable("{{workload}}").include?('load-2')
    assert textilizable("{{workload(#{@project.id})}}").include?('load-1')

    workload = textilizable("{{workload(#{@project.identifier})}}")
    assert workload.include?('load-2')
    assert workload.include?(@project.name)

    workloadFilterByCustomValue = textilizable("{{workload(#{@project.identifier}, {:#{@custom_field.name}=>testValue})}}")
    assert workloadFilterByCustomValue.include?(@project.name)

    workloadFilterWithUnknownCustomValue = textilizable("{{workload(#{@project.identifier}, {:#{@custom_field.name}=>unknownTestValue})}}")
    assert !workloadFilterWithUnknownCustomValue.include?(@project.name)
  end
end

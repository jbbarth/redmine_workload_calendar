require "spec_helper"
require 'redmine_workload/macros'

describe "RedmineWorkload::Macros", type: :helper do
  include ApplicationHelper
  include ERB::Util

  fixtures :projects, :custom_fields, :custom_values, :trackers, :users, :issue_statuses

  before do
    @project = Project.create!(:name => "Project X", :identifier => "project-x")
    @custom_field = ProjectCustomField.create!(:name => 'newCustomField', :field_format=>'list', :possible_values=>['Environment', 'testValue'])
    @custom_value = CustomValue.create!(customized_type:'Project', customized_id:@project.id, custom_field_id: @custom_field.id, value: "testValue")
    Version.create!(:name=>"Dumb version 1", :project_id => @project.id, :version_load_id => 2, :effective_date => Date.today)
    Version.create!(:name=>"Dumb version 2", :project_id => @project.id, :version_load_id => 3, :effective_date => Date.today+1.day)
    Version.create!(:name=>"Dumb version 3", :project_id => @project.id, :version_load_id => 3, :effective_date => Date.today+15.days)
    @tracker = Tracker.first
    Issue.create!(:subject=>"New issue", :project_id => @project.id, :start_date => Date.today-1.month, :due_date => Date.today-10.days, :tracker => @tracker, :author=>User.first )
  end

  it "should workload macro" do
    assert textilizable("{{workload}}").include?('load-2')
    assert textilizable("{{workload(#{@project.id})}}").include?('load-1')

    workload = textilizable("{{workload(#{@project.identifier})}}")
    assert workload.include?('load-2')
    assert workload.include?(@project.name)

    workloadFilterByCustomValue = textilizable("{{workload(#{@project.identifier}, {:#{@custom_field.name}=>testValue})}}")
    assert workloadFilterByCustomValue.include?(@project.name)

    workloadFilterWithUnknownCustomValue = textilizable("{{workload(#{@project.identifier}, {:#{@custom_field.name}=>unknownTestValue})}}")
    assert !workloadFilterWithUnknownCustomValue.include?(@project.name)

    # second argument has no effect if its format is not correct
    workload_filter_with_incorrect_second_argument = textilizable("{{workload(#{@project.identifier}, wrongFormat>unknownTestValue)}}")
    expect(textilizable("{{workload(#{@project.identifier})}}")).to eq workload_filter_with_incorrect_second_argument
  end

  it "should workload_by_issues macro" do
    assert textilizable("{{workload_by_issues}}").include?('workload-week-tip')
    assert textilizable("{{workload_by_issues(#{@project.id})}}").include?(@project.name)
    assert textilizable("{{workload_by_issues(#{@project.identifier})}}").include?(@project.name)

    workloadFilterByIssueAndTracker = textilizable("{{workload_by_issues(#{@project.identifier}, {:trackers=>#{@tracker.name}})}}")
    assert workloadFilterByIssueAndTracker.include?(@project.name)

    workloadFilterWithUnknownTrackerValue = textilizable("{{workload_by_issues(#{@project.identifier}, {:trackers=>unknownTrackerName})}}")
    assert !workloadFilterWithUnknownTrackerValue.include?(@project.name)

    # second argument has no effect if its format is not correct
    workload_filter_with_incorrect_second_argument = textilizable("{{workload_by_issues(#{@project.identifier}, wrongFormat>unknownTestValue)}}")
    expect(textilizable("{{workload_by_issues(#{@project.identifier})}}")).to eq workload_filter_with_incorrect_second_argument
  end
end

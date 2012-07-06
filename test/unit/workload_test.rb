require File.dirname(__FILE__) + '/../test_helper'

class WorkloadTest < ActiveSupport::TestCase
  setup do
    Setting.plugin_redmine_workload_calendar = {"display_weeks_before"=>"4", "display_weeks_after"=>"16"}
    @project = Project.create!(:name => "Project X", :identifier => "project-x")
    @subproject = Project.create!(:name => "Project Y", :identifier => "project-y", :parent_id => @project.id)
    Version.create!(:name=>"Dumb version 1", :project_id => @project.id, :version_load_id => 2, :effective_date => "2008-08-01")
    Version.create!(:name=>"Dumb version 2", :project_id => @project.id, :version_load_id => 3, :effective_date => "2008-08-02")
  end

  test "Workload creation" do
    w = Workload.new
    assert_not_nil w
    assert_equal 4, Workload.display_weeks_before
    assert_equal 16, Workload.display_weeks_after
    assert_equal Week.today - 4, w.week_from
    assert_equal Week.today + 16, w.week_to
  end
  
  test "Workload#versions" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    assert_equal 2, w.versions.length
    assert_instance_of Version, w.versions.first
  end
  
  test "Workload#projects" do
    w = Workload.new
    assert_equal Project.count, w.projects.length
    w = Workload.new(:project => @subproject)
    assert_equal 1, w.projects.length
  end
  
  test "Workload#load_by_week" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    expected = {200831=>2}
    assert_equal expected, w.load_by_week
  end
  
  test "Workload#weeks" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    assert_equal [26,27,28,29,30,31], w.weeks.map(&:cweek)
  end
  
  test "Ensure Workload#each_week and Workload#weeks are coherent" do
    w = Workload.new
    a = []; w.each_week{|m| a << m}
    assert_equal w.weeks.to_a, a
  end
end

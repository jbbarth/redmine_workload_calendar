require "spec_helper"

describe "Workload" do
  before do
    Setting.plugin_redmine_workload_calendar = {"display_weeks_before"=>"4", "display_weeks_after"=>"16"}
    @project = Project.create!(:name => "Project X", :identifier => "project-x")
    @subproject = Project.create!(:name => "Project Y", :identifier => "project-y", :parent_id => @project.id)
    Version.create!(:name=>"Dumb version 1", :project_id => @project.id, :version_load_id => 2, :effective_date => "2008-08-01")
    Version.create!(:name=>"Dumb version 2", :project_id => @project.id, :version_load_id => 3, :effective_date => "2008-08-02")
  end

  it "should Workload creation" do
    w = Workload.new
    assert_not_nil w
    Workload.display_weeks_before.should == 4
    Workload.display_weeks_after.should == 16
    w.week_from.should == Week.today - 4
    w.week_to.should == Week.today + 16
  end
  
  it "should Workload#versions" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    w.versions.length.should == 2
    assert_instance_of Version, w.versions.first
  end

  it "should Workload#issues" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    assert w.issues.length > 0
    assert_instance_of Issue, w.issues.first
  end
  
  it "should Workload#projects" do
    w = Workload.new
    w.projects.length.should == Project.count
    w = Workload.new(:project => @subproject)
    w.projects.length.should == 1
  end
  
  it "should Workload#load_by_week" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    expected = {200831=>2}
    w.load_by_week.should == expected
  end
  
  it "should Workload#weeks" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    w.weeks.map(&:cweek).should == [26,27,28,29,30,31]
  end
  
  it "should Ensure Workload#each_week and Workload#weeks are coherent" do
    w = Workload.new
    a = []; w.each_week{|m| a << m}
    a.should == w.weeks.to_a
  end
end

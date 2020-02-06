require "spec_helper"

describe "Workload" do

  fixtures :projects, :issues

  before do
    Setting.plugin_redmine_workload_calendar = {"display_weeks_before"=>"4", "display_weeks_after"=>"16"}
    @project = Project.create!(:name => "Project X", :identifier => "project-x")
    @subproject = Project.create!(:name => "Project Y", :identifier => "project-y", :parent_id => @project.id)
    Version.create!(:name=>"Dumb version 1", :project_id => @project.id, :version_load_id => 2, :effective_date => "2008-08-01")
    Version.create!(:name=>"Dumb version 2", :project_id => @project.id, :version_load_id => 3, :effective_date => "2008-08-02")
  end

  it "should Workload creation" do
    w = Workload.new
    refute_nil w
    expect(Workload.display_weeks_before).to eq 4
    expect(Workload.display_weeks_after).to eq 16
    expect(w.week_from).to eq Week.today - 4
    expect(w.week_to).to eq Week.today + 16
  end
  
  it "should Workload#versions" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    expect(w.versions.length).to eq 2
    assert_instance_of Version, w.versions.first
  end

  it "should Workload#issues" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    assert w.issues.length > 0
    assert_instance_of Issue, w.issues.first
  end
  
  it "should Workload#projects" do
    w = Workload.new
    expect(w.projects.length).to eq Project.count
    w = Workload.new(:project => @subproject)
    expect(w.projects.length).to eq 1
  end
  
  it "should Workload#load_by_week" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    expected = {200831=>2}
    expect(w.load_by_week).to eq expected
  end
  
  it "should Workload#weeks" do
    w = Workload.new(:week_from => Week.new(2008,26), :week_to => Week.new(2008,31))
    expect(w.weeks.map(&:cweek)).to eq [26,27,28,29,30,31]
  end
  
  it "should Ensure Workload#each_week and Workload#weeks are coherent" do
    w = Workload.new
    a = []; w.each_week{|m| a << m}
    expect(a).to eq w.weeks.to_a
  end
end

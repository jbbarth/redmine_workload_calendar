require "spec_helper"

describe "VersionLoad" do
  before do
    @project = Project.create!(:name => "Project X", :identifier => "project-x")
    Version.create!(:name=>"Dumb version 1", :project_id => @project.id, :version_load_id => 2, :effective_date => "2008-08-01")
    Version.create!(:name=>"Dumb version 2", :project_id => @project.id, :version_load_id => 3, :effective_date => "2008-08-02")
    Version.create!(:name=>"Dumb version 3", :project_id => @project.id, :version_load_id => 3, :effective_date => "2008-08-16")
    @workload = Workload.new(:week_from => Week.new(2008,31), :week_to => Week.new(2008,36))
  end

  it "should #initialize" do
    expect(@workload.week_from.to_i).to eq 200831
    expect(@workload.week_to.to_i).to eq 200836
  end

  it "should #versions" do
    assert @workload.versions.present?
  end

  it "should #projects" do
    assert @workload.projects.include?(@project)
  end
  
  it "should #load_by_week" do
    expected = {200831=>2,200833=>1}
    expect(@workload.load_by_week).to eq expected
  end

  it "should Version#version_load_id is in Version#safe_attributes" do
    v = Version.new(:name => 'V1')
    v.safe_attributes = {'description' => 'final', 'version_load_id' => 2}
    expect(v.description).to eq 'final' #ensures we don't break existing safe_attributes
    expect(v.version_load_id).to eq 2
  end
end

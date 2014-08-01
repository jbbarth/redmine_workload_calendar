require File.dirname(__FILE__) + '/../test_helper'

class VersionLoadTest < ActiveSupport::TestCase
  setup do
    @project = Project.create!(:name => "Project X", :identifier => "project-x")
    Version.create!(:name=>"Dumb version 1", :project_id => @project.id, :version_load_id => 2, :effective_date => "2008-08-01")
    Version.create!(:name=>"Dumb version 2", :project_id => @project.id, :version_load_id => 3, :effective_date => "2008-08-02")
    Version.create!(:name=>"Dumb version 3", :project_id => @project.id, :version_load_id => 3, :effective_date => "2008-08-16")
    @workload = Workload.new(:week_from => Week.new(2008,31), :week_to => Week.new(2008,36))
  end

  test "#initialize" do
    assert_equal 200831, @workload.week_from.to_i
    assert_equal 200836, @workload.week_to.to_i
  end

  test "#versions" do
    assert @workload.versions.present?
  end

  test "#projects" do
    assert @workload.projects.include?(@project)
  end
  
  test "#load_by_week" do
    expected = {200831=>2,200833=>1}
    assert_equal expected, @workload.load_by_week
  end

  test "Version#version_load_id is in Version#safe_attributes" do
    v = Version.new(:name => 'V1')
    v.safe_attributes = {'description' => 'final', 'version_load_id' => 2}
    assert_equal 'final', v.description #ensures we don't break existing safe_attributes
    assert_equal 2, v.version_load_id
  end
end

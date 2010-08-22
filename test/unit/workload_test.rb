require File.dirname(__FILE__) + '/../test_helper'

class WorkloadTest < ActiveSupport::TestCase
  test "Workload creation" do
    w = Workload.new
    assert_not_nil w
  end
  
  test "Workload#versions" do
    w = Workload.new
    assert !w.versions.empty?
    assert w.versions.first.is_a?(Version)
  end
  
  test "Workload#projects" do
    w = Workload.new
    assert_equal 6, w.projects.length
    w = Workload.new(:project => Project.find(1))
    assert_equal 5, w.projects.length
  end
  
  test "Workload#load_by_week" do
    w = Workload.new
    expected = {35=>1}
    assert_instance_of Hash, w.load_by_week
    assert_equal expected, w.load_by_week
  end
end

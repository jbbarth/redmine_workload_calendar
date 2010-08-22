require File.dirname(__FILE__) + '/../test_helper'

class WorkloadTest < ActiveSupport::TestCase
  test "Workload creation" do
    w = Workload.new
    assert_not_nil w
    assert_equal Date.today - 30, w.date_from
    assert_equal Date.today + 120, w.date_to
  end
  
  test "Workload#versions" do
    w = Workload.new(:date_from => Date.new(2006,7,1), :date_to => Date.new(2006,7,31))
    assert_equal 2, w.versions.length
    assert_instance_of Version, w.versions.first
  end
  
  test "Workload#projects" do
    w = Workload.new
    assert_equal 6, w.projects.length
    w = Workload.new(:project => Project.find(1))
    assert_equal 5, w.projects.length
  end
  
  test "Workload#load_by_week" do
    w = Workload.new(:date_from => Date.new(2006,7,1), :date_to => Date.new(2006,7,31))
    expected = {26=>2}
    assert_equal expected, w.load_by_week
  end
end

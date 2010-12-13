require File.dirname(__FILE__) + '/../test_helper'

class WorkloadTest < ActiveSupport::TestCase
  test "Workload creation" do
    w = Workload.new
    assert_not_nil w
    assert_equal Week.today - 4, w.week_from
    assert_equal Week.today + 16, w.week_to
  end
  
  test "Workload#versions" do
    w = Workload.new(:week_from => Week.new(2006,26), :week_to => Week.new(2006,31))
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
    w = Workload.new(:week_from => Week.new(2006,26), :week_to => Week.new(2006,31))
    expected = {200626=>2}
    assert_equal expected, w.load_by_week
  end
  
  test "Workload#weeks" do
    w = Workload.new(:week_from => Week.new(2006,26), :week_to => Week.new(2006,31))
    assert_equal [26,27,28,29,30,31], w.weeks.map(&:cweek)
  end
  
  test "Ensure Workload#each_week and Workload#weeks are coherent" do
    w = Workload.new
    a = []; w.each_week{|m| a << m}
    assert_equal w.weeks.to_a, a
  end
end

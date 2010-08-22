require File.dirname(__FILE__) + '/../test_helper'

class VersionLoadTest < ActiveSupport::TestCase
  test "Version#load_weeks" do
    Version.create!(:name=>"Dumb version 1", :project_id => 1, :version_load_id => 2, :effective_date => "2008-08-01")
    Version.create!(:name=>"Dumb version 2", :project_id => 1, :version_load_id => 3, :effective_date => "2008-08-02")
    w = Workload.new(:date_from => Date.new(2008,8), :date_to => Date.new(2008,9))
    expected = {30=>1,31=>2,32=>2}
    assert_equal expected, w.load_by_week
  end
end

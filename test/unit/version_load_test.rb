require File.dirname(__FILE__) + '/../test_helper'

class VersionLoadTest < ActiveSupport::TestCase
  test "Version#load_period" do
    Version.create!(:name=>"Dumb version 1", :project_id => 1, :version_load_id => 2, :effective_date => "2008-08-01")
    Version.create!(:name=>"Dumb version 2", :project_id => 1, :version_load_id => 3, :effective_date => "2008-08-02")
    w = Workload.new(:week_from => Week.new(2008,31), :week_to => Week.new(2008,36))
    expected = {200831=>2,200832=>2,200833=>1}
    assert_equal expected, w.load_by_week
  end
end

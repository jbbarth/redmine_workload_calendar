require File.expand_path('../../../test_helper', __FILE__)

class WorkloadHelperTest < ActionView::TestCase
  include WorkloadHelper
  include Redmine::I18n
  include ERB::Util

  fixtures :projects, :versions

  test "tooltip helper doesn't raise if a version doesn't have an associated version_load" do
    v = Version.find(1)
    assert_nil v.version_load
    assert_nothing_raised do
      h = workload_version_tooltip(v)
    end
  end
end

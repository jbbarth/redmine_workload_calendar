require "spec_helper"

describe WorkloadHelper do
  include WorkloadHelper
  include Redmine::I18n
  include ERB::Util

  fixtures :projects, :versions

  it "should tooltip helper doesn't raise if a version doesn't have an associated version_load" do
    v = Version.find(1)
    expect(v.version_load).to be_nil
    expect{workload_version_tooltip(v)}.to_not raise_error
  end
end

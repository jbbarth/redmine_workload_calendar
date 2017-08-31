require "spec_helper"

describe "versions/new.html.erb", type: :view do
  let(:user) { User.find(2) }

  before do
    User.current = user
    assign(:project, Project.find(1))
    assign(:version, Version.new)
    view.extend ProjectsHelper
  end

  it "contains 'load' select tag" do
    render
    assert_select 'input[name=?]', 'version[name]', :count => 1
    assert_select 'select[name=?]', 'version[version_load_id]', :count => 1
  end
end

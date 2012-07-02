if Redmine::VERSION::MAJOR <= 1
  # Rails 2.3
  ActionController::Routing::Routes.draw do |map|
    map.resources :version_loads, :only => [:edit, :update]
  end
else
  # Rails 3
  RedmineApp::Application.routes.draw do
    resources :version_loads, :only => [:edit, :update]
  end
end

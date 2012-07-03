RedmineApp::Application.routes.draw do
  resources :version_loads, :only => [:edit, :update]
end

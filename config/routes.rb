ActionController::Routing::Routes.draw do |map|
  map.resources :version_loads, :only => [:edit, :update]
end

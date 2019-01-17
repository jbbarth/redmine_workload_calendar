class VersionLoadsController < ApplicationController
  unloadable
  
  layout 'admin'
  
  before_action :require_admin
  
  def edit
    @version_load = VersionLoad.find(params[:id])
  end
  
  def update
    @version_load = VersionLoad.find(params[:id])
    @version_load.safe_attributes = params[:version_load]
    if @version_load.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to(:controller => 'settings', :action => 'plugin', :id => 'redmine_workload_calendar')
    else
      render :action => "edit"
    end
  end
end

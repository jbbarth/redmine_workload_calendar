class VersionLoadsController < ApplicationController
  unloadable
  
  layout 'admin'
  
  before_filter :require_admin
  
  def edit
    @version_load = VersionLoad.find(params[:id])
  end
  
  def update
    @version_load = VersionLoad.find(params[:id])
    if @version_load.update_attributes(params[:version_load])
      flash[:notice] = l(:notice_successful_update)
      redirect_to(:controller => 'settings', :action => 'plugin', :id => 'redmine_workload_calendar')
    else
      render :action => "edit"
    end
  end
end

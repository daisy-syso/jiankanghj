class Frontend::AppsController < FrontendController
  
  def index
    @app = AppInformationType.all
  end

  def more_apps
    @apps = AppInformation.where(type_id: params[:app_type_id])
  end
end
class Frontend::AppsController < FrontendController
  before_action :set_video_category, only: [:show, :more_videos]
  before_action :set_video, only: [:show]
  
  def index
    @app = AppInformationType.all
  end
end
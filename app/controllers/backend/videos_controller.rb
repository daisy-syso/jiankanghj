class Backend::VideosController < BackendController
  before_action :set_video_category, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  def index
    search = params[:search]
    query_head = []
    query_body = {}

    if search.present?
      query_head << "album_name like :search"
      query_body[:search] = "%#{search}%"
    end

    # @goodfriends = Goodfriend.where(query_head.join(" and "),query_body).order("convert(name using gbk)").page(params[:page])

    @videos = @video_category.videos.where(query_head.join(" and "), query_body).order("created_at desc").page(params[:page]).per(params[:per])

    @video_categories = VideoCategory.all.pluck(:id, :name)
  end

  def move
    video = Video.find(params[:id])
    video.video_category_id = params[:video_category_id]
    
    if video.save
      render :json => {
        message: 'ok'
      }.to_json
    end
  end

  # GET /videos/1
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  def create
    @video = Video.new(video_params)

    if @video.save
      redirect_to @video, notice: 'Video was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /videos/1
  def update
    if @video.update(video_params)
      redirect_to @video, notice: 'Video was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /videos/1
  def destroy
    @video.destroy
    redirect_to backend_video_category_videos_path, notice: 'Video was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_category
      @video_category = VideoCategory.find(params[:video_category_id])
    end

    def set_video
      @video = @video_category.videos.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def video_params
      params.require(:video).permit(:album_name, :pic_url, :play_url, :tv_id, :create_time, :time_length, :sub_title, :html5_url, :html5_play_url, :video_category)
    end
end

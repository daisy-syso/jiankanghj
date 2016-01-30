class VideoCategoriesController < ApplicationController
  before_action :set_video_category, only: [:show, :edit, :update, :destroy]

  # GET /video_categories
  def index
    @video_categories = VideoCategory.all
  end

  # GET /video_categories/1
  def show
  end

  # GET /video_categories/new
  def new
    @video_category = VideoCategory.new
  end

  # GET /video_categories/1/edit
  def edit
  end

  # POST /video_categories
  def create
    @video_category = VideoCategory.new(video_category_params)

    if @video_category.save
      redirect_to @video_category, notice: 'Video category was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /video_categories/1
  def update
    if @video_category.update(video_category_params)
      redirect_to @video_category, notice: 'Video category was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /video_categories/1
  def destroy
    @video_category.destroy
    redirect_to video_categories_url, notice: 'Video category was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_category
      @video_category = VideoCategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def video_category_params
      params.require(:video_category).permit(:name, :iqiyi_id)
    end
end

require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  setup do
    @video = videos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:videos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create video" do
    assert_difference('Video.count') do
      post :create, video: { album_name: @video.album_name, create_time: @video.create_time, html5_play_url: @video.html5_play_url, html5_url: @video.html5_url, pic_url: @video.pic_url, play_url: @video.play_url, sub_title: @video.sub_title, time_length: @video.time_length, tv_id: @video.tv_id, video_category: @video.video_category }
    end

    assert_redirected_to video_path(assigns(:video))
  end

  test "should show video" do
    get :show, id: @video
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @video
    assert_response :success
  end

  test "should update video" do
    patch :update, id: @video, video: { album_name: @video.album_name, create_time: @video.create_time, html5_play_url: @video.html5_play_url, html5_url: @video.html5_url, pic_url: @video.pic_url, play_url: @video.play_url, sub_title: @video.sub_title, time_length: @video.time_length, tv_id: @video.tv_id, video_category: @video.video_category }
    assert_redirected_to video_path(assigns(:video))
  end

  test "should destroy video" do
    assert_difference('Video.count', -1) do
      delete :destroy, id: @video
    end

    assert_redirected_to videos_path
  end
end

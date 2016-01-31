class Backend::EditorsSessionController < BackendController

  def create
    email = params[:editor][:email]
    password = params[:editor][:password]
    editor = Editor.where(email: email).first
    if editor && editor.password == password
      session[:editor] = editor.email
      redirect_to backend_video_categories_path
    else
      redirect_to login_backend_editors_session_index_path
    end
  end

  def login
    if session[:editor].present?
      redirect_to backend_video_categories_path
    else
      @editor = Editor.new
    end
  end

  def logout
    session[:editor] = nil

    redirect_to login_backend_editors_session_index_path
  end

  private
  def editor_params
    params.require(:editor).permit(:email, :password)
  end
end

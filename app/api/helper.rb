module Helper
  extend Grape::API::Helpers

  def strong_params(params)
    ActionController::Parameters.new(params)
  end

  def current_user
    @current_user ||= User.where(auth_token: params[:auth_token]).first
  end

  def authenticate!
    current_user
  end

  def page
    params[:page]
  end

  def per
    params[:per]
  end

  def generate_uuid
    SecureRandom.uuid
  end

  def register_params(params)
    strong_params(params).require(:user).permit(:email, :telephone, :username, :password)
  end

  def update_params(params)
    strong_params(params).require(:user).permit(:is_online, :is_indexed, :username, :gender, :summary, :university, :last_online_time, :description, :credit, :avatar, :age, :profession, :password, {location: [:lon, :lat]}, :address, :email, :university, :telephone, :platform_id)
  end

  def article_params(params)
    strong_params(params).require(:article).permit(:content, {location: [:lon, :lat]}, :is_show, :address)
  end

  def information_params(params)
    strong_params(params).require(:information).permit(:content, {location: [:lon, :lat]}, :is_show, :address, :genre, :gender_require, :target_user_id)
  end

  def comment_params(params)
    strong_params(params).require(:comment).permit(:content)
  end

  def device_params(params)
    strong_params(params).require(:device).permit(:device_token, :alias_type, :alias_name, :device_type)
  end

  def feedback_params(params)
    strong_params(params).require(:feedback).permit(:username, :category, :content, :telephone, :email, :user_agent, :platform)
  end

  def report_params(params)
    strong_params(params).require(:report).permit(:content, :article_id, :reporter_id)
  end

  def foot_params(params)
    strong_params(params).require(:foot).permit(:content, {location: [:lon, :lat]}, :upload_time, :address)
  end

  private
    def current_user
      auth_token = params.auth_token
      if auth_token.blank?
        raise Errors::AuthTokenError.new :missing
      end

      auth_token = auth_token.gsub(' ', '+')
      # qSwxF6douB3UdRnAHukiwYgryF6RfasaIw8WOu+XPQHY3SYpz6cjG8aF9wl6fmKb+xylazHTQGaWvPEJGPdisA==
      @current_user = User.where(auth_token: auth_token).first
      unless @current_user
        raise Errors::AuthTokenError.new :invalid
      end

      @current_user
    end
end
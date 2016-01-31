class BackendController < ApplicationController
  layout 'backend/application'

  def check_auth
    if session[:editor] == nil
      redirect_to '/editors_session/login'
    end
  end
end

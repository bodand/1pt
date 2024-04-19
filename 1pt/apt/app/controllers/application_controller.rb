class ApplicationController < ActionController::Base
  before_action :load_current_user

  private

  def load_current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

end

class SessionsController < ApplicationController

  def login
    @user = User.authenticate(params[:user][:username], params[:user][:password])
    if @user
      session[:user_id] = @user.id
      return redirect_to root_page_path
    end
    flash[:errors] = [ "Username or password is incorrect" ]
    redirect_back fallback_location: root_page_path
  end

  def logout
    reset_session
    redirect_to root_page_path
  end
end

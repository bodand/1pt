class UsersController < ApplicationController
  def register
    @user = User.new
  end

  def login
    @user = User.new
  end

  def create
    @user = User.new(user_register_params)
    if @user.save
      session[:user_id] = @user.id
      return redirect_to login_path
    end
    flash[:errors] = @user.errors.full_messages
    redirect_back fallback_location: root_page_path
  end

  def edit
    return redirect_to root_page_path unless @current_user
    return redirect_to user_edit_path(@current_user.id) if @current_user.id != params[:id].to_i

    @user = @current_user
  end

  def update
    unless @current_user.update(user_update_params)
      flash[:errors] = @current_user.errors.full_messages
    end
    redirect_back fallback_location: root_page_path
  end

  def update_password
    @params = user_password_params
    @user = @current_user.authenticate @params[:current_password]
    unless @user
      flash[:errors] = [ "Invalid password" ]
      return redirect_back fallback_location: root_page_path
    end

    @user.update(@params.permit(:password, :password_confirmation))
    if @user.save
      flash[:notices] = ["Saved successfully"]
    else
      flash[:errors] = @user.errors.full_messages
    end

    redirect_back fallback_location: root_page_path
  end

  def api_list
    @users = User.where('lower(name) LIKE ?', "#{params[:q].downcase}%").all
  end

  private

  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
  
  def user_update_params
    params.require(:user).permit(:name, :username, :email)
  end

  def user_register_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end
end

class UserController < ApplicationController
  def register
    @user = User.new
  end

  def login
    @user = User.new
  end

  def logout
  end

  def edit
    @user = User.new name: 'Teszt Béla', username: 'tb', email: 'bela@test.org'
  end

  def api_list
    # todo: this action does filtering
    @users = [
      User.new(name: 'Teszt Béla', id: 1),
      User.new(name: 'Teszt Xavér', id: 2),
      User.new(name: 'Teszt Eleonóra', id: 3),
    ]
  end

end

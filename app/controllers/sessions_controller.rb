class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome Back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid username/password combination"
      render :new
    end
  end

  def destroy
  end
end

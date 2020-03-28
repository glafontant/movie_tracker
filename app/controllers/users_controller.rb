class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    return render :new if @user.errors.any?
    redirect_to @user, notice: "Thank you for signing up!"
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    return render :edit if @user.errors.any?
    redirect_to @user, notice: "Account successfully updated!"
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, danger: "Account was successfully delete"
  end

  private
    def user_params
      params.require(:user).
        permit(:name, :username, :email, :password, :password_confirmation)
    end
end

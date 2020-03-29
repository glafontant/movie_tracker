class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]

  before_action :require_correct_user, only: [:edit, :update, :destroy]

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
    session[:user_id] = @user.id
    return render :new if @user.errors.any?
    redirect_to @user, notice: "Thank you for signing up!"
  end

  def edit; end

  def update
    @user.update(user_params)
    return render :edit if @user.errors.any?
    redirect_to @user, notice: "Account successfully updated!"
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to users_url, danger: "Account was successfully delete"
  end

  private
    def user_params
      params.require(:user).
        permit(:name, :username, :email, :password, :password_confirmation)
    end

    def require_corrrect_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user == @user
    end
end

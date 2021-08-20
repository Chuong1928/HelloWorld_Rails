class UsersController < ApplicationController
  include SessionsHelper
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: [:edit, :update, :index]
  before_action :correct_user, only: [:edit, :update]
  before_action :isAdmin, only: [:destroy]

  # GET /users or /users.json
  def index
   
    @users = User.paginate(page: params[:page])
    
  end

  # GET /users/1 or /users/1.json
  def show
    
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  # def create
  #   @user = User.new(user_params)

  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: "User was successfully created." }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
    
    #call back kiểm tra xem đã đăng nhập hay chưa
    def logged_in_user
      unless !!current_user.present?
        store_location
        flash[:notice] = "Please log in."
        redirect_to login_url
        end
    end
    #function trả về  user tránh việc phải gọi truy xuất db nhiều lần
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to(root_url) 
        flash[:alert] = "Bạn không có quyền này."
      end
    end
    def isAdmin
      unless current_user.role?
        redirect_to(root_url) 
        flash[:notice] = "Bạn không có quyền xóa! Bạn không phải admin."
        end
    end
end

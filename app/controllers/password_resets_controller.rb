class PasswordResetsController < ApplicationController
  include SessionsHelper
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Case (1)
  def new

  end

  def create
    @user = User.find_by(email: params[:a][:email])
    if @user #nếu tồn tại user
      @user.create_reset_digest   #tạo ra mã resetpassword -> lưu vào database
      @user.send_password_reset_email   #gửi mail cho user
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
    
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
        render 'edit'
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end

  end
  private
      
    def user_params
        params.require(:user).permit(:password, :password_confirmation)
    end


    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
         unless (@user && @user.authenticated?(:reset, params[:id]))
                redirect_to root_url
          end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
         flash[:danger] = "Password reset has expired."
         redirect_to new_password_reset_url
      end
    end
  
end


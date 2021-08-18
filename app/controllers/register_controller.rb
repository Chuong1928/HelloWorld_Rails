class RegisterController < ApplicationController
   layout "session"
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
    
        respond_to do |format|
          if @user.save
            format.html { redirect_to users_path, notice: "User was successfully created." }
            format.json { render :show, status: :created, location: @user }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
    end
    
      # Only allow a list of trusted parameters through.
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end

class RelationshipsController < ApplicationController
    include SessionsHelper
    layout "front_end"
    before_action :logged_in_user

    def create
        @user = User.find(params[:tag][:followed_id])
        current_user.follow(@user)
        respond_to do |format|
            format.html { redirect_to @user }
            format.js 
        end
    end
    def destroy
        @user = Relationship.find(params[:id]).followed
        current_user.unfollow(@user)
        respond_to do |format|
            format.html { redirect_to @user }
            format.js
        end
    end

     #call back kiểm tra xem đã đăng nhập hay chưa
     def logged_in_user
        unless !!current_user.present?
          store_location
          flash[:notice] = "Please log in."
          redirect_to login_url
          end
      end
end

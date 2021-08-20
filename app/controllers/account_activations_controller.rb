class AccountActivationsController < ApplicationController
    include SessionsHelper
    def edit
        user = User.find_by(email: params[:email])
        #kiểm tra xem user đã active hay chưa và mã xác thực có đúng hay không
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate
            log_in user
            flash[:success] = "Account activated!"
            redirect_to user
        else
            flash[:danger] = "Invalid activation link"
             root_url
        end
    end
end

class SessionsController < ApplicationController
  layout "login"
  include SessionsHelper
  def new

  end
  def create
      user = User.find_by(email: params[:session][:email])
      if user && user.authenticate(params[:session][:password])
         
            log_in user
            params[:session][:remember_me] == '1' ? remember(user) : forget(user)
            redirect_back_or user
        
      else
        flash.now[:notice] = 'Invalid email/password combination'
        render "new"
      end
  end

  def destroy
      log_out
      redirect_to root_path
  end

end

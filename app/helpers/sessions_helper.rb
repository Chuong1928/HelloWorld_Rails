module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    #khi user click remember me 
    def remember(user)
        user.remember # gọi đến hàm remeber trong model để  sinh mã remember_digest 
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user
        if (user_id = session[:user_id]) # nếu tồn tại user_id trong seesion chưa
            @current_user ||= User.find_by(id: session[:user_id])
        elsif (user_id = cookies.signed[:user_id]) #nếu tồn tại user_id trong cookies (đã đăng nhập trước đó)
            user = User.find_by(id: user_id)
            #kiểm tra nếu tồn tại user đã đăng nhập trước đó và có remeber lại
            if user && user.authenticated?(:remember, cookies[:remember_token]) 
                log_in user
                @current_user = user
            end
        end
    end
    def current_user?(user)
        user && user == current_user
        end

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    # Redirects to stored location (or to the default).
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
    # Stores the URL trying to be accessed.
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end 
end

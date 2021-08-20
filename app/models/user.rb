class User < ApplicationRecord
   
    attr_accessor :remember_token, :activation_token
    before_create :create_activation_digest
    has_many :microposts
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: true
    has_secure_password

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    #khi client login thanh cong 
    #-> he thong se tao ra 1 cookie de luu thong tin xac thuc nguoi dung
    #Cookie này sẽ tồn tại trên trình duyệt web cho đến khi người dùng đăng xuất hệ thống
    #khi user login thì server sẽ sinh ra session, lưu ở server ( trong memory của ram hoặc 
    #save file, tuỳ). Đồng thời server sẽ set header trên response trả về client,
    # mục đích của header này là lưu cookie ở phía client.
    # Trong cookie sẽ có session_id tương ứng với session ở server. 
    #Nhờ đó mà server biết dc ai thực hiện các request ở lần tiếp theo.
    #nếu user ko check vào remember me thì khi server set header sẽ KHÔNG bao gồm expired date cho cookie.
    #khi browser nhận dc lệnh tạo cookie mà ko có expired date, thì nó hiểu đây là "session cookie" - đặc điểm của loại cookie này là khi user tắt browser thì nó xoá cookie này.
    #lúc đó user phải đăng nhập lại.
    #nếu user check vào remember me thì server khi set header SẼ BAO GỒM expired date ( vd 1 năm sau) thi khi user tắt browser cookie này vẫn còn.
    #khi cookie còn hạn thì user còn đăng nhập hoài.
    
    #tao ra 1 mã ngẫu nhiên làm mã thông báo
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    #gán mã(dạng băm) vào [remember_digest] database cho user
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

     # kiểm tra xem [remember_token] của phiên làm việc hiện tại
     # có giống với [remember_digest] đã lưu hay khong. nếu đúng thì đăng nhập thành công
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    #XÁC THỰC NGƯỜI DÙNG LOGIC
    # sau khi người dùng tạo tại khoản -> hệ thống sẽ tự tạo ra 1 mã xác thực
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end

    # Activates an account.
    def activate
        update_attribute(:activated,true)
        update_attribute(:activated_at, Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end


end

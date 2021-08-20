class AddActivationToUsers < ActiveRecord::Migration[6.0]
  def change
    # mã xác thực tài khoản
    add_column :users, :activation_digest, :string
    #mặc định trạng thái kích hoạt tài khoản = false
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
  end
end

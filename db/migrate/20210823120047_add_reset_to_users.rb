class AddResetToUsers < ActiveRecord::Migration[6.0]
  def change
    #mã reset pass
    add_column :users, :reset_digest, :string
    add_column :users, :reset_sent_at, :datetime
  end
end
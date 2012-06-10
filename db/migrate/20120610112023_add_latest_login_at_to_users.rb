class AddLatestLoginAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :latest_login_at, :timestamp
  end
end

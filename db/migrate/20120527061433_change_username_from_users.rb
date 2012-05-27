class ChangeUsernameFromUsers < ActiveRecord::Migration
  def up
    rename_column :users, :username, :bookshelf_name
  end
end

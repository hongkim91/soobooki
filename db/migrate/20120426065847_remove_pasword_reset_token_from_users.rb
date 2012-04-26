class RemovePaswordResetTokenFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :pasword_reset_token
      end

  def down
    add_column :users, :pasword_reset_token, :string
  end
end

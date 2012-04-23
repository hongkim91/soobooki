class RemoveProfilePicFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :profile_pic
      end

  def down
    add_column :users, :profile_pic, :string
  end
end

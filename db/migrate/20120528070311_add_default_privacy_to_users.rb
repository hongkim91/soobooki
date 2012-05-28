class AddDefaultPrivacyToUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :bookshelf_privacy, "Friends"
  end
end

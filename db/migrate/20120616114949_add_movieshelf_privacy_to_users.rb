class AddMovieshelfPrivacyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :movieshelf_privacy, :string, default: "Users"
  end
end

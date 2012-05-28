class AddBookshelfPrivacyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bookshelf_privacy, :string
  end
end

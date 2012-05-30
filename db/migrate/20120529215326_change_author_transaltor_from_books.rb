class ChangeAuthorTransaltorFromBooks < ActiveRecord::Migration
  def up
    rename_column :books, :author, :authors
    rename_column :books, :translator, :translators
  end
end

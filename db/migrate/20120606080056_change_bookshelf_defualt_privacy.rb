class ChangeBookshelfDefualtPrivacy < ActiveRecord::Migration
  def up
    change_column_default :users, :bookshelf_privacy, "Users"
  end
end

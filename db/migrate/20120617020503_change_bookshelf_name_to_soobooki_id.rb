class ChangeBookshelfNameToSoobookiId < ActiveRecord::Migration
  def change
    rename_column :users, :bookshelf_name, :soobooki_id
  end
end

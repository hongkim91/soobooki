class RenameBookSearchEngine < ActiveRecord::Migration
  def up
    rename_column :users, :book_search_engine, :book_api
  end
end

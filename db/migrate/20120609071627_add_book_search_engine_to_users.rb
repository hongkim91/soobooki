class AddBookSearchEngineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :book_search_engine, :string, default: "daum"
  end
end

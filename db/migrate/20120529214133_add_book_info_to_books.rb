class AddBookInfoToBooks < ActiveRecord::Migration
  def change
    add_column :books, :author, :string
    add_column :books, :translator, :string
    add_column :books, :publisher, :string
    add_column :books, :pub_date, :timestamp
    add_column :books, :category, :string
    add_column :books, :isbn, :string
    add_column :books, :isbn13, :string
    add_column :books, :api_id, :string
  end
end

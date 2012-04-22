class RemoveReviewFromBook < ActiveRecord::Migration
  def up
    remove_column :books, :review
      end

  def down
    add_column :books, :review, :text
  end
end

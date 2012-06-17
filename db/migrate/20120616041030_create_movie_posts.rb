class CreateMoviePosts < ActiveRecord::Migration
  def change
    create_table :movie_posts do |t|
      t.integer :movie_id
      t.integer :user_id
      t.text :review
      t.integer :year, default: 0
      t.integer :month, default: 0
      t.integer :day, default: 0
      t.string :privacy, default: "Friends"
      t.string :title
      t.string :image

      t.timestamps
    end
  end
end

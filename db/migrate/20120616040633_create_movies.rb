class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :director
      t.string :actors
      t.string :release_date
      t.string :api_id
      t.string :image

      t.timestamps
    end
  end
end

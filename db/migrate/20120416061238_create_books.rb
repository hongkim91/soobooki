class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :review
      t.string :image_url

      t.timestamps
    end
  end
end

class ChangePubDateFromBooks < ActiveRecord::Migration
  def up
    change_column :books, :pub_date, :string
  end
end

class RemoveTypeFromNotifications < ActiveRecord::Migration
  def up
    remove_column :notifications, :type
      end

  def down
    add_column :notifications, :type, :string
  end
end

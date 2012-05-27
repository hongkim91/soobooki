class RemoveNotifiableColumnsFromNotification < ActiveRecord::Migration
  def up
    remove_column :notifications, :notifiable_id
    remove_column :notifications, :notifiable_type
  end
end

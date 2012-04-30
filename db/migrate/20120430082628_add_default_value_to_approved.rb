class AddDefaultValueToApproved < ActiveRecord::Migration
  def change
    change_column :friendships, :approved, :boolean, :default => true
  end
end

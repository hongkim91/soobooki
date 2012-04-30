class ChangeDefaultValueToApproved < ActiveRecord::Migration
  def up
    change_column :friendships, :approved, :boolean, :default => false
  end
end

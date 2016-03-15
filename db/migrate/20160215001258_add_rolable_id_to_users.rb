class AddRolableIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rolable_id, :integer
  end
end

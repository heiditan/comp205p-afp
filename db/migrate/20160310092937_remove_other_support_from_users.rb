class RemoveOtherSupportFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :other_support, :string
  end
end

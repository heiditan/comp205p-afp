class RemoveOtherSupportSoughtFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :other_support_sought, :string
  end
end

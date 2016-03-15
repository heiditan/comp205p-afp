class AddOtherSupportSoughtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :other_support_sought, :string
  end
end

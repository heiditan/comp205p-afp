class AddOtherSupportToUsers < ActiveRecord::Migration
  def change
    add_column :users, :other_support, :string
  end
end

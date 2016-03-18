class AddOtherSupportOfferedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :other_support_offered, :string
  end
end

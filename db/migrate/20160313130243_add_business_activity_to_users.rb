class AddBusinessActivityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :business_activity, :string
  end
end

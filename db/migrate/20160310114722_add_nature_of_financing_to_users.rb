class AddNatureOfFinancingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nature_of_financing, :string
  end
end

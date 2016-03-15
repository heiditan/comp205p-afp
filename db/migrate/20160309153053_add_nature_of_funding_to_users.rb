class AddNatureOfFundingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nature_of_funding, :string
  end
end

class AddCeoNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ceo_name, :string
  end
end

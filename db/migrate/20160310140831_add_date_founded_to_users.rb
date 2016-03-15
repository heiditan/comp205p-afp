class AddDateFoundedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :date_founded, :date
  end
end

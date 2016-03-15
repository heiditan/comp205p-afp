class CreateSmes < ActiveRecord::Migration
  def change
    create_table :smes do |t|

      t.timestamps null: false
    end
  end
end

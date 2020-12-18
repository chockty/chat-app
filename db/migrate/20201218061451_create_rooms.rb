class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|

      t.timestamps
      t.string :name, null: false
    end
  end
end

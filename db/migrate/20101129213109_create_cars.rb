class CreateCars < ActiveRecord::Migration
  
  def up
    create_table :cars do |t|
      t.string :producent, :null => false
      t.string :brand, :null => false
      t.string :color, :null => false
      t.decimal :max_speed, :null => false, :precision => 10, :scale => 2
      t.timestamps
    end
  end

  # add index ...

  def down
    drop_table :cars
  end
  
end

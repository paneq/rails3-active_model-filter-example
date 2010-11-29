class ValidityDatesForCars < ActiveRecord::Migration

  def up
    add_column :cars, :valid_from, :date
    add_column :cars, :valid_to, :date
  end

  def down
    remove_column :cars, :valid_from
    remove_column :cars, :valid_to
  end
  
end

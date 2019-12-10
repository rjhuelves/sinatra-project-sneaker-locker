class CreateSneakers < ActiveRecord::Migration

  def change
    create_table :sneakers do |t|
      t.string :brand
      t.string :model
      t.string :colorway
      t.integer :cost
      t.integer :user_id
    end 
  end

end

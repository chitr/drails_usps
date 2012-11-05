class CreateDummies < ActiveRecord::Migration
  def change
    create_table :dummies do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end

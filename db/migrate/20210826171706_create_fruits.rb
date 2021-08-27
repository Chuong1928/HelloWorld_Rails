class CreateFruits < ActiveRecord::Migration[6.0]
  def change
    create_table :fruits do |t|
      t.string :name
      t.timestamps
    end
  end
end

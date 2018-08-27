class CreateSamples < ActiveRecord::Migration[5.2]
  def change
    create_table :samples do |t|
      t.string :name
      t.text :memo
      t.timestamps
    end
  end
end

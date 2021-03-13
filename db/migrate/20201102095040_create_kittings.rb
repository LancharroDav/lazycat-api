class CreateKittings < ActiveRecord::Migration[6.0]
  def change
    create_table :kittings do |t|
      t.references :kit, null: false, foreign_key: true
      t.references :bookmark, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.string :url
      t.string :title
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

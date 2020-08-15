class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :image
      t.references :user, foreign_key: true
      t.text :ingredients
      t.references :category, foreign_key: true
      t.text :journey
      t.text :trick

      t.timestamps
    end
  end
end

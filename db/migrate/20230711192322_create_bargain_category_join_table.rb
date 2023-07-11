class CreateBargainCategoryJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :bargain_categories do |t|
      t.references :bargain, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end

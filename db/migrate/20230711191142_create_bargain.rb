class CreateBargain < ActiveRecord::Migration[7.0]
  def change
    create_table :bargains do |t|
      t.string :title
      t.boolean :active
      t.datetime :ends_at
      t.text :description
      t.string :link
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

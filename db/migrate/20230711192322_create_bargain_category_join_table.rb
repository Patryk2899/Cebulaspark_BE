class CreateBargainCategoryJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :bargains, :categories do |t|
      t.index %i[bargain_id category_id]
      t.timestamps
    end
  end
end

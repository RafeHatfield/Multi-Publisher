class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id, :null => false
      t.integer :article_id, :null => false
      t.integer :stars

      t.timestamps
    end

		add_index :ratings, :article_id
  end
end

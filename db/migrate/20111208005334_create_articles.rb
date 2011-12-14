class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id, :null => false

      t.string :title, :null => false
      t.text :teaser, :null => false
      t.text :body, :null => false
      t.string :version
      t.text :changelog

      t.text :freezebody
      t.integer :state, :null => false, :default => 0
      t.string :message
      t.date :submitted
      t.date :accepted

      t.timestamps
    end

		add_index :articles, :user_id
  end
end

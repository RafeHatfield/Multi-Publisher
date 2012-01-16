class CreateFinalboardingcalls < ActiveRecord::Migration
  def change
    create_table :finalboardingcalls do |t|
      t.string :old_url
      t.string :new_url
      t.integer :redirect_type

      t.timestamps
    end
  end
end
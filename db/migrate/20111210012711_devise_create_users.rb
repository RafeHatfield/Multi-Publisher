class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
			t.confirmable
			t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :time

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable
			
			# author information
			t.string :fullname
			t.text :shortbio
			t.string :weburl
			t.integer :country_id, :null => false, :default => 1


      t.timestamps
    end

		add_index :users, :fullname                                           
		add_index :users, :country_id
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
		add_index :users, :confirmation_token,	 :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

end

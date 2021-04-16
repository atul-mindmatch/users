class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email

      t.timestamps
    end

    create_table :user_details do |t|
      t.string :first_name
      t.string :last_name
      t.date   :dob
      t.string :address
      t.bigint :user_id
      t.timestamps
    end

    add_index :user_details, :user_id
  end
end

class CreateUserDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :user_details do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.date   :dob
      t.belongs_to :user


      t.timestamps
    end
  end
end

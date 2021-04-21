class AddPhoneNoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone_no, :bigint
  end
end

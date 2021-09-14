class RemovePhoneNumberFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :phone_no, :bigint
  end
end

class RemoveAddressFromUserDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_details, :address, :string
  end
end

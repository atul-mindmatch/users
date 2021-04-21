class AddCollumnsToUserDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :user_details, :primary_address, :string
    add_column :user_details, :secondary_address, :string
  end
end

class UserDetail < ApplicationRecord
    belongs_to :user
    validates :dob , if: :greater_than_18?
end



def greater_than_18?
    return false
end

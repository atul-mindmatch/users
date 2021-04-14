class User < ApplicationRecord
    has_one :user_detail , dependent: :destroy
    validates :username, presence: true
    validates :email, presence: true
    validates :email, uniqueness: true
    validates :username, uniqueness: true
end

class UserDetail < ApplicationRecord
  belongs_to :user
  validates :dob, presence: true
  validate :age_greater_than_18?

  def age_greater_than_18?
    temp_dob = dob.to_s.split('-')
    if dob > 18.years.ago
      errors.add(:dob, "age must be greater than 18")
    end
  end
end



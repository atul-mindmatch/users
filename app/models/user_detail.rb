class UserDetail < ApplicationRecord
  belongs_to :user
  validate :age_greater_than_18?

  def age_greater_than_18?
    temp_dob = dob.to_s.split('-')
    if temp_dob[0].to_i > 2002
      errors.add(:dob, "age must be greater than 18")
    end
  end
end



require 'rails_helper'

RSpec.describe User, type: :model do
  context "validation tests" do
      it 'ensures email is not blank' do
        user = User.new(username: "justpiyoosh" ).save
        expect(user).to eq(false)
      end

      it 'ensures username is not blank' do
        user = User.new(email: "justpiyoosh@gmail.com").save
        expect(user).to eq(false)
      end

      it 'ensures usernmae uniqueness' do
        user = User.new(email: "justpiyoosh@gmail.com" , username: "justpiyoosh").save
        expect(user).to eq(true)
      end
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
   
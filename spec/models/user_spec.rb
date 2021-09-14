require 'rails_helper'

RSpec.describe User, type: :model do
  context "validation tests" do
    let(:user) { build (:user)}
    #let(:user) { create (:user )}
      it 'ensures email is not blank' do
        # user = User.new(username: "justpiyoosh" ).save
        user.email = nil
        expect(user.save).to eq(false)
      end

      it 'ensures username is not blank' do
        # user = User.new(email: "justpiyoosh@gmail.com").save
        user.username = nil
        expect(user.save).to eq(false)
      end

      it 'ensures usernmae uniqueness' do
        # user = User.new(email: "justpiyoosh@gmail.com" , username: "justpiyoosh").save
        user.username = "afalflajj"
        expect(user.save).to eq(true)
      end
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
   
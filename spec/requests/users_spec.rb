require 'rails_helper'



RSpec.describe "Users", type: :request do
  describe "GET /users" do

    it "creates a user and redirects to the user's page" do
      get "/users/new"
      expect(response).to render_template(:new)
    end
    it "fethces all the users " do
      get "/users"
      expect(response).to render_template(:index)
    end
    it "creates a user and store in db" do
      user_data = { :user => {:username => "123" , :email => "email@gmail.com"} ,:user_detail => {:first_name => "First" , :last_name => "Last" , :dob => "2001-09-09" , :primary_address => "a;lfja alfaj falfj" , :secondary_address => "sdjfahjfbaljkdfbalk"} }
      post "/users", :params => user_data
      expect(User.last.username).to eq("123")
      expect(User.last.email).to eq("email@gmail.com")

      post "/users", :params => user_data
      expect(response.location).to include("/users/new")

    end
  end

end

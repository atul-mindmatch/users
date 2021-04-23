FactoryBot.define do
    factory :user do
         username {"justpiyoosh07"}
         email    {"justpiyoosh07@gmail.com"}
    end


    factory :random_user, class: User do
        username {Faker::Name.username}
        email    {Faker::Internet.safe_email}
   end
end
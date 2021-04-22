FactoryBot.define do
    factory :user do
         username {"usdfderiname"}
         email    {"ussfsfernkiame@gmail.com"}
         phone_no {8896136036}
    end


    factory :random_user, class: User do
        username {Faker::Name.username}
        email    {Faker::Internet.safe_email}
        phone_no {8896136036}
   end
end
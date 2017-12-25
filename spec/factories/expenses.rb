FactoryBot.define do
  factory :expense do
    date { Date.today }
    amount { Faker::Number.between(10, 500) }
    description { Faker::Company.name }
    payer_id { create(:user).id }
    payer_share { Faker::Number.between(10, amount) }
    couple { create(:couple) }
  end
end
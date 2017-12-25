FactoryBot.define do
  factory :payment do
    date { Date.today }
    amount { Faker::Number.between(10, 500) }
    payer_id { create(:user).id }
    couple { create(:couple) }
  end
end
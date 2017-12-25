class Balance < ApplicationRecord
  has_one :user, inverse_of: :balance
end

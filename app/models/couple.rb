class Couple < ApplicationRecord
  has_many :categories, inverse_of: :couple
  has_many :users, inverse_of: :couple
  has_many :transactions, inverse_of: :couple
end

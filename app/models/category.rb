class Category < ApplicationRecord
  include CoupleConcern
  acts_as_paranoid

  validates :name, presence: true
end

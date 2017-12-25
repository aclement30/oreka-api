class Expense < Transaction
  validates :description, presence: true, length: { maximum: 255 }
  validates :payer_share, presence: true
end
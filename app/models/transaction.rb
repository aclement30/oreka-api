class Transaction < ApplicationRecord
  include CoupleConcern
  include UserConcern
  acts_as_paranoid

  belongs_to :category, required: false
  belongs_to :user, foreign_key: 'payer_id', inverse_of: :transactions

  attribute :currency, :string, default: 'CAD'

  validates :date, presence: true
  validates :amount, presence: true
  validates :notes, length: { maximum: 255 }

  after_save :update_balances
  after_destroy :update_balances

  def update_balances
    partner = couple.users.where.not(id: user.id).first

    # Calculate partner transactions balance
    partner_transactions = Transaction.by_couple(couple).where(payer_id: partner.id)
    partner_expenses = Expense.by_couple(couple).where(payer_id: partner.id)
    partner_transactions_balance = partner_transactions.sum(:amount) - partner_expenses.sum(:payer_share)

    # Calculate user transactions balance
    user_transactions = Transaction.by_couple(couple).where(payer_id: payer_id)

    user_expenses = Expense.by_couple(couple).where(payer_id: payer_id)
    user_transactions_balance = user_transactions.sum(:amount) - user_expenses.sum(:payer_share)

    # Calculate couple balance for current user
    user_balance = user_transactions_balance - partner_transactions_balance

    Balance.transaction do
      user.balance.amount = user_balance
      user.balance.save!

      partner.balance.amount = user_balance * -1
      partner.balance.save!
    end
  end
end

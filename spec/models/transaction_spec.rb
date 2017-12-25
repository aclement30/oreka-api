require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:couple) { create(:couple) }
  let!(:user_balance) { create(:balance) }
  let!(:partner_balance) { create(:balance) }
  let!(:user) do
    user = build(:user)
    user.couple = couple
    user.balance = user_balance
    user.save!
    user
  end
  let!(:partner) do
    partner = build(:user)
    partner.couple = couple
    partner.balance = partner_balance
    partner.save!
    partner
  end

  describe 'when initializing' do
    it 'sets balance to 0' do
      expect(user.balance.amount).to eq(0.0)
      expect(partner.balance.amount).to eq(0.0)
    end
  end

  describe 'when creating expense' do
    let(:new_expense) do
      build(:expense, amount: 130, payer_id: user.id, payer_share: 50, couple: couple)
    end

    it 'updates balances accordingly' do
      new_expense.save!

      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(80.0)
      expect(partner_balance.amount).to eq(-80.0)
    end

    it 'includes user\'s other expenses in balance' do
      # Create existing expense
      create(:expense, amount: 120, payer_id: user.id, payer_share: 60, couple: couple)

      # Save new expense
      new_expense.save!

      user_balance.reload
      partner_balance.reload

      # Balance should equal 80 + 60 = 140
      expect(user_balance.amount).to eq(140.0)
      expect(partner_balance.amount).to eq(-140.0)
    end

    it 'includes partner\'s expenses in balance' do
      # Create existing expense for partner
      create(:expense, amount: 120, payer_id: partner.id, payer_share: 100, couple: couple)

      # Save new expense
      new_expense.save!

      user_balance.reload
      partner_balance.reload

      # Balance should equal 80 - 20 = 60
      expect(user_balance.amount).to eq(60.0)
      expect(partner_balance.amount).to eq(-60.0)
    end

    it 'includes user\'s other payments in balance' do
      # Create existing payment
      create(:payment, amount: 120, payer_id: user.id, couple: couple)

      # Save new expense
      new_expense.save!

      user_balance.reload
      partner_balance.reload

      # Balance should equal 80 + 120 = 200
      expect(user_balance.amount).to eq(200.0)
      expect(partner_balance.amount).to eq(-200.0)
    end

    it 'includes partner\'s payments in balance' do
      # Create existing partner's payment
      create(:payment, amount: 120, payer_id: partner.id, couple: couple)

      # Save new expense
      new_expense.save!

      user_balance.reload
      partner_balance.reload

      # Balance should equal 80 - 120 = 40
      expect(user_balance.amount).to eq(-40.0)
      expect(partner_balance.amount).to eq(40.0)
    end
  end

  describe 'when editing expense' do
    let!(:expense) do
      create(:expense, amount: 130, payer_id: user.id, payer_share: 50, couple: couple)
    end

    it 'updates balances accordingly' do
      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(80.0)
      expect(partner_balance.amount).to eq(-80.0)

      expense.update({ amount: 120 })

      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(70.0)
      expect(partner_balance.amount).to eq(-70.0)
    end
  end

  describe 'when deleting expense' do
    let!(:expense) do
      create(:expense, amount: 130, payer_id: user.id, payer_share: 50, couple: couple)
    end

    it 'updates balances accordingly' do
      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(80.0)
      expect(partner_balance.amount).to eq(-80.0)

      expense.destroy

      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(0.0)
      expect(partner_balance.amount).to eq(0.0)
    end
  end

  describe 'when creating payment' do
    let(:new_payment) do
      build(:payment, amount: 130, payer_id: user.id, couple: couple)
    end

    it 'updates balances accordingly' do
      new_payment.save!

      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(130.0)
      expect(partner_balance.amount).to eq(-130.0)
    end

    it 'includes user\'s other expenses in balance' do
      # Create existing expense
      create(:expense, amount: 120, payer_id: user.id, payer_share: 60, couple: couple)

      # Save new payment
      new_payment.save!

      user_balance.reload
      partner_balance.reload

      # Balance should equal 130 + 60 = 190
      expect(user_balance.amount).to eq(190.0)
      expect(partner_balance.amount).to eq(-190.0)
    end

    it 'includes partner\'s expenses in balance' do
      # Create existing expense for partner
      create(:expense, amount: 120, payer_id: partner.id, payer_share: 100, couple: couple)

      # Save new payment
      new_payment.save!

      user_balance.reload
      partner_balance.reload

      # Balance should equal 130 - 20 = 110
      expect(user_balance.amount).to eq(110.0)
      expect(partner_balance.amount).to eq(-110.0)
    end

    it 'includes user\'s other payments in balance' do
      # Create existing payment
      create(:payment, amount: 120, payer_id: user.id, couple: couple)

      # Save new payment
      new_payment.save!

      user_balance.reload
      partner_balance.reload

      # Balance should equal 130 + 120 = 250
      expect(user_balance.amount).to eq(250.0)
      expect(partner_balance.amount).to eq(-250.0)
    end

    it 'includes partner\'s payments in balance' do
      # Create existing partner's payment
      create(:payment, amount: 120, payer_id: partner.id, couple: couple)

      # Save new payment
      new_payment.save!

      user_balance.reload
      partner_balance.reload

      # Balance should equal 130 - 120 = 10
      expect(user_balance.amount).to eq(10.0)
      expect(partner_balance.amount).to eq(-10.0)
    end
  end

  describe 'when editing payment' do
    let!(:payment) do
      create(:payment, amount: 130, payer_id: user.id, couple: couple)
    end

    it 'updates balances accordingly' do
      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(130.0)
      expect(partner_balance.amount).to eq(-130.0)

      payment.update({ amount: 120 })

      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(120.0)
      expect(partner_balance.amount).to eq(-120.0)
    end
  end

  describe 'when deleting payment' do
    let!(:payment) do
      create(:payment, amount: 150, payer_id: user.id, couple: couple)
    end

    it 'updates balances accordingly' do
      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(150.0)
      expect(partner_balance.amount).to eq(-150.0)

      payment.destroy

      user_balance.reload
      partner_balance.reload

      expect(user_balance.amount).to eq(0.0)
      expect(partner_balance.amount).to eq(0.0)
    end
  end
end
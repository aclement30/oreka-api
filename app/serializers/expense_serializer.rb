class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :date, :description, :amount, :currency, :payer_share, :payer_id, :notes, :category_id

  def date
    Date.parse(object.date).strftime('%Y-%m-%d')
  end
end

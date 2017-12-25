class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :date, :amount, :currency, :payer_id, :notes

  def date
    Date.parse(object.date).strftime('%Y-%m-%d')
  end
end

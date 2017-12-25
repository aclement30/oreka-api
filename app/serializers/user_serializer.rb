class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :name, :initials, :email, :balance

  def balance
    object.balance.amount
  end
end

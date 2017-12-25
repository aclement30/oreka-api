class CoupleSerializer < ActiveModel::Serializer
  attributes :id

  has_many :users, each_serializer: UserSerializer

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :name, :initials, :email
  end
end

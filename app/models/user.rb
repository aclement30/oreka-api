class User < ApplicationRecord
  acts_as_paranoid

  has_many :transactions
  has_many :auth_providers, inverse_of: :user, dependent: :destroy
  belongs_to :balance, required: true
  belongs_to :couple, required: false

  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }

  def name
    "#{first_name} #{last_name}"
  end

  def initials
    first_name.first + last_name.first
  end

  def self.find_for_jwt_authentication(id)
    find(id)
  end

  def self.create_from_auth(provider, request, user_hash)
    balance = Balance.new()
    user = create!(
            first_name: user_hash['given_name'],
            last_name: user_hash['family_name'],
            email: user_hash['email'],
            picture_url: user_hash['picture'],
            balance: balance,
    )
    AuthProvider.create!(
                    user: user,
                    provider: 'google',
                    uid: user_hash['sub']
    )
    user
  end

  def jwt_subject
    id
  end
end

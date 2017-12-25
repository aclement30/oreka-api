module UserConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :user

    scope :by_user, lambda { |user|
      where(:user => user)
    }
  end
end
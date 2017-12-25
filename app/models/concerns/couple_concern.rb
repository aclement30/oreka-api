module CoupleConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :couple

    scope :by_couple, lambda { |couple|
      where(:couple => couple)
    }
  end
end
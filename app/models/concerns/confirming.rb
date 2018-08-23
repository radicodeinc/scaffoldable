module Confirming
  extend ActiveSupport::Concern

  CONFIRMED_KEY = "1".freeze
  UNCONFIRMED_KEY = "".freeze
  CONFIRMED_BACK_KEY = "back".freeze

  included do
    validates :confirming, acceptance: { accept: Confirming::CONFIRMED_KEY }

    before_validation :check_confirming_back
    after_validation :check_confirming
  end

  def confirming?
    confirming == Confirming::CONFIRMED_KEY
  end

  def confirming_back?
    confirming == Confirming::CONFIRMED_BACK_KEY || @is_confirming_back == true
  end

  private

  def check_confirming_back
    @is_confirming_back = confirming_back?
    self.confirming = Confirming::UNCONFIRMED_KEY if @is_confirming_back
    true
  end

  def check_confirming
    errors.delete(:confirming)
    self.confirming = errors.empty? ? Confirming::CONFIRMED_KEY : nil unless @is_confirming_back
    true
  end
end

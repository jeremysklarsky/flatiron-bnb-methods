class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :check_eligibility, :check_availability, :valid_range

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * duration
  end

  private
    def check_eligibility
      errors.add(:listing, "must not be your own listing") unless listing.host_id != self.guest_id
    end

    def check_availability
      if has_dates
        errors.add(:listing, "must be available") unless listing.avail?(checkin, checkout)
      end
    end

    def valid_range
      if has_dates
        errors.add(:listing, "must be valid range") unless self.checkin < self.checkout
      end
    end

    def has_dates
      checkin && checkout
    end

end

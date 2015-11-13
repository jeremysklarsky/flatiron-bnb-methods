class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, :description, :reservation_id, presence: true
  validate :res_accepted_and_over

  def res_accepted_and_over
    if self.reservation
      errors.add(:reservation, "must be over") unless (self.reservation.status == "accepted") && (Date.today > self.reservation.checkout)
    end
  end

end

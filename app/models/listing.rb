class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_save :add_host_status
  before_destroy :remove_host_status

  def avail?(start, finish)

    range = (start..finish).map(&:to_s)
    (range & booked_dates).empty?

    # range = (start..finish).map(&:to_s)
    # (range - booked_dates).length > 0

  end

  def trips
    self.reservations.collect do |reservation|
      (reservation.checkin.to_s..(reservation.checkout).to_s).to_a
    end
  end

  def booked_dates
    trips.flatten
  end

  def average_review_rating

    self.reviews.collect{|review|review.rating}.inject(:+) / self.reviews.size.to_f
  end

  private
    def add_host_status
      self.host.host = true if self.host.listings.size > 0  
      self.host.save
    end

    def remove_host_status      
      self.host.host = false if self.host.listings.size == 1
      self.host.save
    end

end

class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  def neighborhood_openings(start, finish)
    self.listings.collect do |listing|
      listing if listing.avail?(start, finish)
    end
  end

  def res_to_listings_ratio
    self.listings.size.to_f / self.reservations.size
  end

  # class methods

  def self.highest_ratio_res_to_listings
    Neighborhood.all.select{|hood| hood.reservations.size > 0}
                .sort_by{|hood|hood.res_to_listings_ratio}
                .first
  end

  def self.most_res
    Neighborhood.all.sort_by {|hood| hood.reservations.size}.last
  end


end

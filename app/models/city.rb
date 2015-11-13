class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  include Mathable::InstanceMethods
  extend Mathable::ClassMethods


  def city_openings(start, finish)
    self.listings.collect do |listing|
      listing if listing.avail?(start, finish)
    end
  end

  def res_to_listings_ratio
    self.listings.size.to_f / self.reservations.size  
  end

  # class methods

  def self.highest_ratio_res_to_listings
    City.all.sort_by {|city| city.res_to_listings_ratio}.first
  end

  def self.most_res
    City.all.sort_by {|city| city.reservations.size}.last
  end

end


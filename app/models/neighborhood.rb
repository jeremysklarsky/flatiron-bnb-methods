class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings
  include Mathable::InstanceMethods
  extend Mathable::ClassMethods


  def neighborhood_openings(start, finish)
    openings(start, finish)
  end
end

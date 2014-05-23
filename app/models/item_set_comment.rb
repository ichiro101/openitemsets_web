class ItemSetComment < ActiveRecord::Base

  belongs_to :item_set
  belongs_to :user

  validates_length_of :comment, :minimum => 5, :maximum => 2000

end

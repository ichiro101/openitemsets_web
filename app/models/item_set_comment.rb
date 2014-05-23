class ItemSetComment < ActiveRecord::Base

  belongs_to :item_set
  belongs_to :user

end

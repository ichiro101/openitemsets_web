class ItemSet < ActiveRecord::Base
  has_many :item_set_blocks, :dependent => :delete_all
  belongs_to :user

end

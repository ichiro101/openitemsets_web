class ItemSetBlock < ActiveRecord::Base
  has_many :block_items, :dependent => :delete_all
end

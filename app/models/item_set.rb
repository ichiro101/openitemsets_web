class ItemSet < ActiveRecord::Base
  ROLES = [
    "Top",
    "Mid",
    "Support",
    "Marksman",
    "Jungle"
  ]

  has_many :item_set_blocks, :dependent => :delete_all
  belongs_to :user

  validates :champion, :inclusion => {:in => Champion.names}
  validates :role, :inclusion => {:in => ROLES}

end

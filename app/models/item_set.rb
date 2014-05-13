class ItemSet < ActiveRecord::Base
  # Define the roles that are valid for the item set
  ROLES = [
    "Top",
    "Mid",
    "Support",
    "Marksman",
    "Jungle"
  ]

  # This class solely exists to get around
  # rails-bootstrap-forms's dumb limitation in the collections helper
  class Visibility
    attr_accessor :id, :value
    def self.all
      hidden =  Visibility.new
      hidden.id = false
      hidden.value = "Hidden"

      visible =  Visibility.new
      visible.id = true
      visible.value = "Visible"

      [
        hidden, visible
      ]
    end
  end

  has_many :item_set_blocks, :dependent => :delete_all
  belongs_to :user

  validates :champion, :inclusion => {:in => Champion.names}, :presence => true
  validates :role, :inclusion => {:in => ROLES}, :presence => true

end

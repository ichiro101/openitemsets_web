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

  # active record relations of ItemSet
  has_many :item_set_blocks, :dependent => :delete_all
  belongs_to :user

  # rails validations
  validates :champion, :inclusion => {:in => Champion.names}, :presence => true
  validates :role, :inclusion => {:in => ROLES}, :presence => true

  def champion_image_url
    "http://static.openitemsets.com/img/champion/#{self.champion}.png"
  end

  def display_name
    if self.title.blank?
      "Untitled Item Set, #{self.champion}: #{self.role}"
    else
      self.title
    end
  end

end

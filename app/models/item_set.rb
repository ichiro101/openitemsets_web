class ItemSet < ActiveRecord::Base
  # Define the roles that are valid for the item set
  ROLES = [
    "Top",
    "Mid",
    "Support",
    "Marksman",
    "Jungle"
  ]

  # constants for map_option
  MAP_OPTION_ALL_MAPS = 1
  MAP_OPTION_SELECTED_MAP = 0

  # constans for map
  MAP_SUMMONERS_RIFT = 1
  MAP_CRYSTAL_SCAR = 8
  MAP_TWISTED_TREELINE = 10
  MAP_HOWLING_ABYSS = 12

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
  belongs_to :user

  has_many :subscriptions, :dependent => :delete_all
  has_many :item_set_comments, :dependent => :delete_all

  # rails validations
  validates :champion, :inclusion => {:in => Champion.names}, :presence => true
  validates :role, :inclusion => {:in => ROLES}, :presence => true

  before_save :parse_json

  after_create :subscribe_owner

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

  def to_game_json(pretty = false)
    # don't bother if item_set_json is empty
    if self.item_set_json.blank?
      return
    end

    item_set_object = JSON.parse(item_set_json)

    # convert all the item id's to string (this is needed
    # for the league client to reconize the item id's)
    item_set_object['blocks'].each do |item_block|
      item_block['items'].each do |item_obj|
        item_obj['id'] = item_obj['id'].to_s
      end
    end

    if self.map_option == MAP_OPTION_ALL_MAPS
      isGlobalForMaps = true
    else
      isGlobalForMaps = false
    end

    item_set_object = item_set_object.merge({
      :mode => 'any',
      :title => self.display_name,
      :sortrank => 1,
      :isGlobalForMaps => isGlobalForMaps,
      :isGlobalForChampions => false,
      :champion => self.champion,
      :type => "custom",
      :priority => false
    })

    if pretty
      JSON.pretty_generate(item_set_object)
    else
      item_set_object.to_json
    end
  end

  def subscribe_owner
    if self.user_id.blank?
      # skip if we don't have any user record associated with this
      # item set
      return
    end

    Subscription.create(:item_set_id => self.id, :user_id => self.user_id)
  end

  private

  def parse_json
    if !self.item_set_json.blank?
      begin
        item_set_object = JSON.parse(self.item_set_json)

        if item_set_object['associatedMaps'].length == 0
          self.map_option = MAP_OPTION_ALL_MAPS
          self.map = nil
        else
          self.map_option = MAP_OPTION_SELECTED_MAP
          self.map = item_set_object['associatedMaps'].first
        end
      rescue
        self.errors.add(:base, 'errors occured while trying to parse JSON')
      end
    end

  end

end

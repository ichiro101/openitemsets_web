class Subscription < ActiveRecord::Base

  belongs_to :user
  belongs_to :item_set

  validates :item_set,
    :presence => true
  validates :user,
    :presence => true

  validate :subscription_uniqueness

  private

  def subscription_uniqueness
    if !Subscription.where(:user_id => self.user_id, :item_set_id => self.item_set_id).blank?
      errors.add(:base, 'user is already subscribed to this item set')
    end
  end

end

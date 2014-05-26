class Subscription < ActiveRecord::Base

  belongs_to :user
  belongs_to :item_set

  validates :item_set,
    :presence => true
  validates :user,
    :presence => true

  validate :subscription_uniqueness
  
  # hard limit on number of item sets user can subscribe to
  #
  # this number should be very high so during normal use case it will
  # never be reached
  validate :limit_subscriptions

  private

  def subscription_uniqueness
    if !Subscription.where(:user_id => self.user_id, :item_set_id => self.item_set_id).blank?
      errors.add(:base, 'user is already subscribed to this item set')
    end
  end

  def limit_subscriptions
    count = Subscription.where(:user_id => self.user_id).count

    if count >= ItemSet::SUBSCRIPTION_LIMIT
      errors.add(:base, 'cannot subscribe to too many item sets')
    end
  end

end

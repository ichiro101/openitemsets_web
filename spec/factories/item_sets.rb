# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_set do
    title "Generic Ahri Build"
    champion "Ahri"
    role "Mid"
    visible_to_public true
    association :user
    item_set_json(
      { :blocks => [
            {
              :items => [
                {
                  :count => 1,
                  :id => 2003
                },
                {
                  :count => 1,
                  :id => 2004
                }
              ],
              :type => "Consumable"
            },
            {
              :items => [
                {
                  :count => 1,
                  :id => 1056
                }
              ],
              :type => "Starting Items"
            }
          ],
          :map => "any",
          :associatedMaps => []
      }.to_json
    )
  end
end

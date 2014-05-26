require 'factory_girl'

namespace :test_data do

  desc "Create test data"
  task :create => :environment do
    10.times do
      FactoryGirl.create(:user, 
                         :username => Faker::Name.name,
                         :email => Faker::Internet.email,
                         :password => "12345")
    end
    puts "user creation done, password all set to 12345"

    100.times do
      FactoryGirl.create(:item_set,
                         :title => Faker::Lorem.sentence,
                         :user => User.all.sample,
                         :champion => Champion.all.sample.id)
    end
    puts "item set creation done"

    250.times do
      FactoryGirl.build(:subscription, 
                        :user => User.all.sample, 
                        :item_set => ItemSet.all.sample).save
    end
    puts "subscription creation done"

    400.times do
      FactoryGirl.create(:item_set_comment, 
                         :user => User.all.sample, 
                         :item_set => ItemSet.all.sample,
                         :comment => Faker::Lorem.paragraph)
    end
    puts "item set comment creation done"

    puts "test data creation done"
  end

end

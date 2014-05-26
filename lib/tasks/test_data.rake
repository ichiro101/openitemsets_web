require 'factory_girl'

namespace :test_data do

  desc "Create test data"
  task :create => :environment do
    10.times do
      FactoryGirl.create(:user, 
                         :username => Faker::Name.name,
                         :email => Faker::Internet.email)
    end

    100.times do
      FactoryGirl.create(:item_set,
                         :title => Faker::Lorem.sentence,
                         :user => User.all.sample,
                         :champion => Champion.all.sample.id)
    end

    250.times do
      FactoryGirl.build(:subscription, 
                        :user => User.all.sample, 
                        :item_set => ItemSet.all.sample).save
    end

    puts "test data creation done"
  end

end

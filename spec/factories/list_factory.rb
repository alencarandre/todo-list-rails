# == Schema Information
#
# Table name: lists
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  user_id     :integer
#  access_type :string(10)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :list do
    sequence :name do |n|
      "List #{n}"
    end

    access_type :public

    user
  end
end

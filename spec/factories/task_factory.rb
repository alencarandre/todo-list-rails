# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  name       :string(100)      not null
#  list_id    :integer
#  status     :string(10)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :task do
    sequence :name do |n|
      "Task #{n}"
    end

    status :not_done

    list
  end
end

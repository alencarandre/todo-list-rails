# == Schema Information
#
# Table name: starred_lists
#
#  id         :integer          not null, primary key
#  list_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StarredList < ApplicationRecord
  scope :by_user, -> (user_id) { where(user_id: user_id) }

  belongs_to :user
  belongs_to :list
end

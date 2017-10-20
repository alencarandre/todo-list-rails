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

require 'rails_helper'

RSpec.describe StarredList, type: :model do

  context 'scope' do
    it 'by_user' do
      expect(StarredList).to receive(:where).with(user_id: 1).and_return([])
      StarredList.by_user(1)
    end
  end
end

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

require 'rails_helper'

RSpec.describe List, type: :model do

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }
  end

  describe 'initialize' do
    it 'access_type should be :public' do
      expect(List.new).to be_public
    end
  end

  context 'scope' do
    it 'by_user' do
      expect(List).to receive(:where).with(user_id: 1).and_return([])
      List.by_user(1)
    end

    it 'public_lists' do
      expect(List).to receive(:where).with(access_type: :public).and_return([])
      List.public_lists
    end

    it 'include_tasks' do
      list = double
      expect(List).to receive(:includes).with(:tasks).and_return(list)
      expect(list).to receive(:references).with(:all).and_return([])
      List.include_tasks
    end

    it 'order_create_at_desc' do
      expect(List).to receive(:order).with(created_at: :desc).and_return([])
      List.order_create_at_desc
    end
  end

  context 'helper method' do
    describe 'public?' do
      it 'should true when access_type is :public' do
        subject.access_type = :public
        expect(subject).to be_public
      end

      it 'should false when access_type is not :public' do
        subject.access_type = :private
        expect(subject).to_not be_public
      end
    end

    describe 'mine?' do
      it 'should be true when user.id == user_id passed' do
        expect(subject.user).to receive(:id).and_return(1)
        expect(subject.mine?(1)).to be_truthy
      end

      it 'should be true when user.id != user_id passed' do
        expect(subject.user).to receive(:id).and_return(1)
        expect(subject.mine?(2)).to be_falsy
      end
    end


    describe 'starred?' do
      before(:each) { subject.stub(starred_lists: double) }

      it 'should be true when have stars' do
        expect(subject.starred_lists).to receive(:by_user).with(1).and_return([1, 2, 3])
        expect(subject.starred?(1)).to be_truthy
      end

      it 'should be false when not have stars' do
        expect(subject.starred_lists).to receive(:by_user).with(1).and_return([])
        expect(subject.starred?(1)).to be_falsy
      end
    end
  end
end

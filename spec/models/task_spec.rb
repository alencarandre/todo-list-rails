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

require 'rails_helper'

RSpec.describe Task, type: :model do

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:list) }
  end

  context 'helper methods' do
    describe 'done?' do
      it 'return true when status is :done' do
        subject.status = :done
        expect(subject.done?).to be_truthy
      end

      it 'return false when status is not :done' do
        subject.status = :not_done
        expect(subject.done?).to be_falsy
      end
    end

    describe 'check' do
      it 'status should pass to :not_done if status == :done' do
        expect(subject).to receive(:done?).and_return(true)
        subject.check
        expect(subject.status).to eq(:not_done)
      end

      it 'status should pass to :done if status == :not_done' do
        expect(subject).to receive(:done?).and_return(false)
        subject.check
        expect(subject.status).to eq(:done)
      end
    end
  end

  describe 'initialize' do
    it 'status should be :not_done' do
      expect(Task.new.status).to eq(:not_done)
    end
  end

end

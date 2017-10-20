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

class List < ApplicationRecord
  extend Enumerize

  validates :name, presence: true
  validates :user, presence: true

  belongs_to :user
  has_many :tasks
  has_many :starred_lists

  scope :by_user, -> (user_id){ where(user_id: user_id) }
  scope :public_lists, -> { where(access_type: :public) }
  scope :include_tasks, -> { includes(:tasks).references(:all) }
  scope :order_create_at_desc, -> { order(created_at: :desc) }

  enumerize :access_type, in: [:public, :private]

  def initialize(attributes = {})
    super(attributes)
    self.access_type ||= :public
  end

  def public?
    access_type == :public
  end

  def mine?(user_id)
    user.id == user_id
  end

  def starred?(user_id)
    starred_lists.by_user(user_id).any?
  end
end

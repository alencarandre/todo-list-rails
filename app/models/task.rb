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

class Task < ApplicationRecord
  extend Enumerize

  validates :name, presence: true
  validates :list, presence: true

  belongs_to :list

  default_scope { order(status: :asc, updated_at: :desc)}

  enumerize :status, in: [:done, :not_done]

  def initialize(attributes = {})
    super(attributes)
    self.status ||= :not_done
  end

  def done?
    status == :done
  end

  def check
    if done?
      self.status = :not_done
    else
      self.status = :done
    end
  end
end

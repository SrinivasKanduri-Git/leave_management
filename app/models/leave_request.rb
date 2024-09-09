# frozen_string_literal: true

class LeaveRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :employee
  field :start_date, type: Date
  field :end_date, type: Date
  field :approval, type: Boolean

  validates_presence_of(:start_date, :end_date)
end

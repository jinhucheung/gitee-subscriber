class Log < ApplicationRecord
  self.inheritance_column = :_type_disabled

  scope :by_day, ->(time) { where('created_at >= ? AND created_at <= ?', time.beginning_of_day, time.end_of_day) }
  scope :today, -> { by_day(Time.zone.now) }
  scope :yesterday, -> { by_day(Time.zone.now.yesterday) }
  scope :recent, -> { order('created_at DESC') }
end
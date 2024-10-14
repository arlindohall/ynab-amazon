# frozen_string_literal: true
# typed: true

class DateInverter
  def self.call(date)
    month, day, year = date.split('/')
    [year, month, day].join('-')
  end
end

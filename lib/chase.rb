# frozen_string_literal: true
# typed: true

class Chase
  extend TransactionSource

  def self.find(dir)
    files = Dir.glob("#{dir}/Chase*_Activity*.csv")
    csv = Reader.strip_headers(files)
    new(csv).transaction_list
  end

  def initialize(csv)
    @csv = csv
  end

  def transaction_list
    TransactionList.new(@csv.map { |row| Transaction.new(row[5], row[1]) })
  end
end

require 'csv'

require_relative './transaction'
require_relative './transaction_list'

class Amazon
  def self.find
    files = Dir.glob("amazon*.csv")
    contents = files.map { |f| File.read(f) }
    blob = contents.join("\n").gsub("\n\n", "\n")
    csv = CSV.parse(blob)
    new(csv).transaction_list
  end

  def initialize(csv)
    @csv = csv
  end

  def transactions
    @csv.map { |amount, date| Transaction.new(amount, date) }
  end

  def transaction_list
    TransactionList.new(transactions)
  end
end

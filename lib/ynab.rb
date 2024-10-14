require 'csv'

require_relative './transaction'
require_relative './transaction_list'

class Ynab
  def self.find
    files = Dir.glob("Selected Transactions for*.csv")
    contents = files.map { |f| File.read(f) }
    blob = contents.join("\n").gsub("\n\n", "\n")
    csv = CSV.parse(blob)
    new(csv[1..]).transaction_list
  end

  def initialize(csv)
    @csv = csv
  end

  def transactions
    @csv.map { |line| transaction_for(line) }
      .reject { |transaction| transaction.amount == '0.00' }
  end

  def transaction_for(line)
    Transaction.new(
      line[-3],
      invert_date(line[2])
    )
  end

  def invert_date(date)
    month, day, year = date.split("/")
    [year, month, day].join("-")
  end

  def transaction_list
    TransactionList.new(transactions)
  end
end

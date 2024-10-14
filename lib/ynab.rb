# frozen_string_literal: true
# typed: true

require 'csv'

require_relative './reader'
require_relative './transaction'
require_relative './transaction_list'

class Ynab
  extend TransactionSource

  def self.find(dir)
    files = Dir.glob("#{dir}/Selected Transactions for*.csv")
    csv = Reader.strip_headers(files)
    new(csv).transaction_list
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
    month, day, year = date.split('/')
    [year, month, day].join('-')
  end

  def transaction_list
    TransactionList.new(transactions)
  end
end

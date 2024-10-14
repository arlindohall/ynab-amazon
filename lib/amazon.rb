# frozen_string_literal: true
# typed: true

require 'csv'

require_relative './transaction'
require_relative './transaction_list'
require_relative './transaction_source'

class Amazon
  extend TransactionSource

  def self.find(dir)
    files = Dir.glob("#{dir}/amazon*.csv")
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

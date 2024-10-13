#!/usr/bin/env ruby

require 'csv'
require 'pry'

class Amazon
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

class Ynab
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

class TransactionList
  attr_reader :transactions
  def initialize(transactions)
    @transactions = transactions
  end

  def exclude?(amount)
    transactions.none? { |transaction| transaction.amount == amount }
  end

  def transactions_for(amount)
    transactions.select { |transaction| transaction.amount == amount }
  end
end

class Transaction
  def initialize(amount, date)
    @amount = amount
    @date = date
  end

  def amount
    @amount.gsub(/[$-]/, '')
  end

  def date
    Date.parse(@date)
  end
end

class Untracked
  attr_reader :source, :budget
  def initialize(source, budget)
    @source = source
    @budget = budget
  end

  def report
    missing_from_source + missing_from_budget
  end

  # TODO: Don't find missing, find where they don't match,, same for missing from source
  def missing_from_budget
    all_amounts.filter { |amount| budget.exclude?(amount) }
      .flat_map { |amount| source.transactions_for(amount) }
      .map { |transaction| "missing_from_budget,#{transaction.date},#{transaction.amount}" }
  end

  def missing_from_source
    all_amounts.filter { |amount| source.exclude?(amount) }
      .flat_map { |amount| budget.transactions_for(amount) }
      .map { |transaction| "missing_from_source,#{transaction.date},#{transaction.amount}" }
  end

  def all_amounts
    (
      source.transactions.map(&:amount) +
      budget.transactions.map(&:amount)
    ).uniq
  end
end

class UntrackedFile
  def self.write(content)
    puts content
  end
end

UntrackedFile.write(
  Untracked.new(
    Amazon.find,
    Ynab.find
  ).report
)

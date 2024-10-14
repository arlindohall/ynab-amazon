# frozen_string_literal: true
# typed: true

class TransactionList
  attr_reader :transactions

  def initialize(transactions)
    @transactions = transactions
  end

  def count(amount)
    transactions.count { |transaction| transaction.amount == amount }
  end

  def transactions_for(amount)
    transactions.select { |transaction| transaction.amount == amount }
  end
end

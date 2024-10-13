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

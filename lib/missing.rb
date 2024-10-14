# frozen_string_literal: true
# typed: false

class Missing
  attr_reader :missing_from, :has_extra, :name_of_missing, :name_of_extra

  def initialize(missing_from, has_extra, name_of_missing, name_of_extra)
    @missing_from = missing_from
    @has_extra = has_extra
    @name_of_missing = name_of_missing
    @name_of_extra = name_of_extra
  end

  def call
    all_amounts.flat_map do |amount|
      next [] unless missing_from.count(amount) < has_extra.count(amount)

      extra_rows_for(amount) + missing_rows_for(amount)
    end
  end

  def rows_for(amount, source, name)
    source.transactions_for(amount).map do |transaction|
      next unless transaction.amount == amount

      row(transaction, name)
    end
  end

  def extra_rows_for(amount)
    rows_for(amount, has_extra, name_of_extra)
  end

  def missing_rows_for(amount)
    rows_for(amount, missing_from, name_of_missing)
  end

  def row(transaction, name)
    [
      transaction.date,
      transaction.amount,
      "transaction_from_#{name}",
      "missing_from_#{name_of_missing}"
    ].join(',')
  end

  def all_amounts
    (
      missing_from.transactions.map(&:amount) +
      has_extra.transactions.map(&:amount)
    ).uniq
  end
end

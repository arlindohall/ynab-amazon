# frozen_string_literal: true
# typed: true

class Untracked
  def initialize(source_class, budget_class, dir = "./actual-files")
    @source_class = source_class
    @budget_class = budget_class
    @dir = dir
  end

  def source
    @source ||= @source_class.find(@dir)
  end

  def budget
    @budget ||= @budget_class.find(@dir)
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

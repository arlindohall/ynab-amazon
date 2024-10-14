# frozen_string_literal: true
# typed: true

require_relative './missing'

class Untracked
  attr_reader :source_class, :budget_class, :dir, :source_name

  def initialize(source_class, budget_class, dir = './actual-files', source_name = 'amazon')
    @source_class = source_class
    @budget_class = budget_class
    @dir = dir
    @source_name = source_name
  end

  def source
    @source ||= source_class.find(dir)
  end

  def budget
    @budget ||= budget_class.find(dir)
  end

  def report
    missing_from_source + missing_from_budget
  end

  def missing_from_budget
    Missing.new(source, budget, source_name, :budget).call
  end

  def missing_from_source
    Missing.new(budget, source, :budget, source_name).call
  end
end

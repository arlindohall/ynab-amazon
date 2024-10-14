#!/usr/bin/env ruby
# frozen_string_literal: true
# typed: true

require 'csv'
require 'pry'
require 'sorbet-runtime'

require_relative './lib/amazon'
require_relative './lib/chase'
require_relative './lib/transaction_source'
require_relative './lib/untracked'
require_relative './lib/untracked_file'
require_relative './lib/ynab'

dir = T.let(nil, T.nilable(String))
transaction_source = T.let(Amazon, TransactionSource)

while ARGV.count.positive?
  arg = ARGV.shift
  case arg
  when '-c', '--chase'
    transaction_source = Chase
  else
    dir = arg
  end
end

if dir
  UntrackedFile.write(Untracked.new(transaction_source, Ynab, dir).report)
else
  UntrackedFile.write(Untracked.new(transaction_source, Ynab).report)
end

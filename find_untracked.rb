#!/usr/bin/env ruby
# frozen_string_literal: true
# typed: true

require 'csv'
require 'pry'
require 'sorbet-runtime'

require_relative './lib/amazon'
require_relative './lib/args'
require_relative './lib/chase'
require_relative './lib/transaction_source'
require_relative './lib/untracked'
require_relative './lib/untracked_file'
require_relative './lib/ynab'

transaction_source, dir, source_name = Args.new(ARGV).parse
UntrackedFile.write(Untracked.new(transaction_source, Ynab, dir, source_name).report)

#!/usr/bin/env ruby
# frozen_string_literal: true
# typed: strict

require 'csv'
require 'pry'

require_relative './lib/amazon'
require_relative './lib/untracked'
require_relative './lib/untracked_file'
require_relative './lib/ynab'

if (dir = ARGV[0])
  UntrackedFile.write(Untracked.new(Amazon, Ynab, dir).report)
else
  UntrackedFile.write(Untracked.new(Amazon, Ynab).report)
end

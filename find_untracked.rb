#!/usr/bin/env ruby

require 'csv'
require 'pry'

require_relative "./lib/amazon"
require_relative "./lib/untracked"
require_relative "./lib/untracked_file"
require_relative "./lib/ynab"

UntrackedFile.write(
  Untracked.new(Amazon, Ynab).report
)

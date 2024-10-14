# frozen_string_literal: true
# typed: true

require_relative './date_inverter'

class Chase
  extend TransactionSource

  AMAZON_TRANSACTION_REGEX = /
    ^(
      AMAZON\sMKTPLACE\sPMTS
      | (
        Amazon.com.
        | AMAZON.MKTPL.
        | AMAZON.web.         # Amazon web services, comment this out unless you care
        | AMZN.Mktp.US.
        | Amazon.Digit.       # Amazon Prime Video, comment this out unless you care
        | AMAZON.PRIME.       # Amazon Prime Video, comment this out unless you care
      )\w{9}
      | Amazon.web.services   # Amazon web services, comment this out unless you care
    )$
  /x.freeze

  def self.find(dir)
    files = Dir.glob("#{dir}/Chase*_Activity*.csv")
    csv = Reader.strip_headers(files)
    new(csv).transaction_list
  end

  def initialize(csv)
    @csv = csv
  end

  def transaction_list
    TransactionList.new(relevant_rows.map { |row| Transaction.new(row[5], DateInverter.call(row[1])) })
  end

  def relevant_rows
    @csv.filter do |row|
      transaction_name = row[2]
      transaction_name.match(AMAZON_TRANSACTION_REGEX)
    end
  end
end

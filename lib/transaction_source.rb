# frozen_string_literal: true
# typed: strict

module TransactionSource
  extend T::Sig
  extend T::Helpers

  abstract!
  sig { abstract.params(dir: String).returns(TransactionList) }
  def find(dir); end
end

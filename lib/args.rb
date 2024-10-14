# frozen_string_literal: true
# typed: true

class Args
  attr_reader :transaction_source, :dir, :source_name

  def initialize(argv)
    @argv = argv

    # Defaults
    @dir = './actual-files'
    @transaction_source = T.let(Amazon, TransactionSource)
    @source_name = 'amazon'
  end

  def parse
    parse! unless @argv.empty?
    [
      transaction_source,
      dir,
      source_name
    ]
  end

  def parse!
    while ARGV.count.positive?
      arg = ARGV.shift
      case arg
      when '-c', '--chase'
        @transaction_source = Chase
        @source_name = 'chase'
      else
        @dir = arg.to_s
      end
    end
  end
end

class Transaction
  def initialize(amount, date)
    @amount = amount
    @date = date
  end

  def amount
    @amount.gsub(/[$-]/, '')
  end

  def date
    Date.parse(@date)
  end
end

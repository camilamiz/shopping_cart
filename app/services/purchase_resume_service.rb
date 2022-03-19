#frozen_string_literal: true

class PurchaseResumeService
  BLACK_FRIDAY = '2022/11/25'

  def initialize(products)
    @products = products
  end

  def execute
    if is_black_friday? then @products << gift end

    total_amount = 0
    total_amount_with_discount = 0
    total_discount = 0

    @products.map do|item|
      total_amount += item[:total_amount]
      total_amount_with_discount += item[:total_amount] - item[:discount]
      total_discount += item[:discount]
    end

    {
      total_amount: total_amount,
      total_amount_with_discount: total_amount_with_discount,
      total_discount: total_discount
    }
  end

  private

  def gift
    product = Product.new.gifts.sample
    {
      id: product['id'],
      quantity: 1,
      unit_amount: 0,
      total_amount: 0,
      discount: 0,
      is_gift: true
    }
  end

  def is_black_friday?
    Date.parse(BLACK_FRIDAY) == Date.today
  end
end
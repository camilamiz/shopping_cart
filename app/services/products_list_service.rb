#frozen_string_literal: true

class ProductsListService
  def initialize(products_params)
    @products_params = products_params
  end

  def execute
    products = []

    @products_params.map do |param|
      id = param['id'].to_i
      product = find_product(id)

      if product.present?
        quantity = param['quantity'].to_i
        total_amount = product['amount'] * quantity

        products << {
          id: id,
          quantity: quantity,
          unit_amount: product['amount'].to_i,
          total_amount: total_amount.to_i,
          discount: (total_amount * discount(id)).to_i,
          is_gift: product['is_gift']
        }
      end
    end
    products
  end

  private

  def new_product
    new_product ||= Product.new
  end

  def find_product(id)
    new_product.find(id)
  end

  def discount(id)
    begin
      service = DiscountClientService.new
      response = service.product_discount(id)
      return response.percentage
    rescue => exception
      exception
    end

    return 0
  end
end

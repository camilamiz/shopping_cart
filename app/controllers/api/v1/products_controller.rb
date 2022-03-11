class Api::V1::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def checkout
    products_params.map do |param|
      product = {
        id: param['id'],
        quantity: param['quantity'],
        unit_amount: product(param['id'])['amount'],
        total_amount: product(param['id'])['amount'] * param['quantity'],
        discount: 10,
        is_gift: product(param['id'])['is_gift']
      }
      byebug
    end
  end

  private

  def new_product
    new_product ||= Product.new
  end

  def product(id)
    new_product.find(id)
  end

  def products_params
    params.permit(products: [:id,:quantity])["products"]
  end
end

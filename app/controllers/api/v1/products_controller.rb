#frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token

  BLACK_FRIDAY = '2022/11/25'

  def checkout
    if products_params.present?
      products = ProductsListService.new(products_params).execute

      if validate_shopping_cart(products)
        checkout = purchase_resume(products)
        if is_black_friday? then products << gift end
        checkout[:products] = products

        render json: checkout, status: :ok
        return
      end
   else
    render json: {
      message: "The request body is invalid."
    }, status: :unprocessable_entity
    return
   end
  end

  private

  def purchase_resume(products)
    total_amount = 0
    total_amount_with_discount = 0
    total_discount = 0

    products.map do|item|
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

  def validate_shopping_cart(products)
    gifts = products.filter { |item| item[:is_gift] == true }

    if gifts.count > 0
      render json: {
        message: "Products with id #{gifts.pluck(:id)} are not available for sale."
      }, status: :unprocessable_entity
      return
    end
    return true
  end

  def is_black_friday?
    Date.parse(BLACK_FRIDAY) == Date.today
  end

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

  def products_params
    params.permit(products: [:id,:quantity])["products"]
  end
end

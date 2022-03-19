#frozen_string_literal: true

class Api::V1::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def checkout
    if products_params.present?
      products = ProductsListService.new(products_params).execute

      if validate_shopping_cart(products)
        checkout = PurchaseResumeService.new(products).execute
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

  def products_params
    params.permit(products: [:id,:quantity])["products"]
  end
end

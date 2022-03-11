class CheckoutSerializer < ActiveModel::Serializer
  attributes
    :total_amount,
    :total_amount_with_discount,
    :total_discount
  has_many :products, serializer: ProductSerializer
end
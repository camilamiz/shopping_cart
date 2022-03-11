class ProductSerializer < ActiveModel::Serializer
  attributes
    :id,
    :quantity,
    :unit_amount,
    :total_amount,
    :discount,
    :is_gift
end
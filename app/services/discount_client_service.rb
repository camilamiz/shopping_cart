require './lib/discount_services_pb.rb'

class DiscountClientService
  def initialize
    env = Dotenv.load
    @stub = Discount::Discount::Stub.new(env['DISCOUNT_SERVICE'], :this_channel_is_insecure)
  end

  def product_discount(id)
    req = Discount::GetDiscountRequest.new
    req.productID = id
    @stub.get_discount(req)
  end
end
class Product
  def all
    JSON.parse(IO.read("./lib/products.json"))
  end

  def find(id)
    all.select do |product|
      product["id"] == id
    end.last
  end

  def gifts
    all.filter { |product| product['is_gift'] == true }
  end
end


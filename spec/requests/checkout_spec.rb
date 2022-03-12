require 'rails_helper'

RSpec.describe 'Checkout products', type: :request do
  describe 'POST products#checkout' do
    it 'it returns a successful response when there aren\'t any gifts in the shopping cart' do

    end

    it 'returns a bad request error when there is a gift in the shopping cart' do
    end

    it 'returns a successful response and one extra product as a gift if today is a black friday' do
    end

    it 'returns a sucessful response without applied discounts if the discount service is not available' do

    end
  end
end
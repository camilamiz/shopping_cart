#frozen_string_literal: true

require './lib/discount_services_pb.rb'
require 'active_support/testing/time_helpers'
require 'rails_helper'
require 'json-schema'
require 'grpc_mock/rspec'

RSpec.describe 'Checkout products', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  describe 'POST products#checkout' do
    let(:checkout_schema_file) { File.read("./spec/support/api/schemas/checkout.json") }
    let(:checkout_schema) { JSON.parse(checkout_schema_file) }
    let(:checkout_response_schema_file) { File.read("./spec/support/api/schemas/checkout_response.json") }
    let(:checkout_response_schema) { JSON.parse(checkout_response_schema_file) }
    before { GrpcMock.disable_net_connect! }

    context 'when request attributes for checkout endpoint' do
      context 'are valid' do
        let(:params) do
          {
            products: [
              {
                id: 1,
                quantity: 2
              },
              {
                id: 3,
                quantity: 1
              }
            ]
          }
        end

        it 'returns a successful response with shopping cart resume', :vcr do
          JSON::Validator.validate!(checkout_schema, params)
          post '/api/v1/checkout', params: params

          parsed_response = JSON.parse(response.body)

          JSON::Validator.validate!(checkout_response_schema, response.body)
          expect(response.status).to eq 200
          expect(parsed_response["total_amount"]).to eq parsed_response["products"].pluck("total_amount").sum
          expect(parsed_response["total_discount"]).to eq parsed_response["products"].pluck("discount").sum
          expect(parsed_response["total_amount_with_discount"]).to eq (parsed_response["total_amount"] - parsed_response["total_discount"])
        end

        it 'returns a successful response and one extra product as a gift if today is black friday' do
          travel_to(Time.parse("2022-11-25")) do
            post '/api/v1/checkout', params: params
          end

          products = JSON.parse(response.body)['products']

          expect(response.status).to eq 200
          expect(products.count).to eq 3
          expect(products.filter { |product| product["is_gift"] == true}.count).to eq 1
        end
      end

      context 'are invalid' do
        it 'does not process the request' do
          invalid_params = { products: "" }

          post '/api/v1/checkout', params: invalid_params

          expect(response.status).to eq 422
        end

        it 'returns a bad request error when there is a gift in the shopping cart' do
          params_with_gift = {
            products: [
              {
                id: 1,
                quantity: 2
              },
              {
                id: 6,
                quantity: 1
              }
            ]
          }

          post '/api/v1/checkout', params: params_with_gift

          expect(response.status).to eq 422
        end
      end
    end
  end
end
#frozen_string_literal: true

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

    context 'when request attributes' do
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

        it 'it returns a successful response' do
          JSON::Validator.validate!(checkout_schema, params)
          post '/api/v1/checkout', params: params

          JSON::Validator.validate!(checkout_response_schema, response.body)
          expect(response.status).to eq 200
        end


        it 'returns a successful response and one extra product as a gift if today is black friday' do
          travel_to(Time.parse("2022-11-25")) do
            post '/api/v1/checkout', params: params
          end

          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['products'].count).to eq 3
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

          expect(response.status).to eq 400
        end
      end
    end

    context 'when discount api' do
      it 'is available, it returns a successful response with available discounts applied' do
      end

      it 'is not available, it returns a sucessful response without applied discounts' do

      end
    end
  end
end
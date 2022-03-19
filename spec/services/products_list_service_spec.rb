#frozen_string_literal: true

require './lib/discount_services_pb.rb'
require 'rails_helper'
require 'grpc_mock/rspec'

RSpec.describe 'ProductsListService', type: :service do
  describe 'execute' do
    subject { ProductsListService.new(params) }
    before { GrpcMock.disable_net_connect! }

    context 'when it receives product params' do
      let(:params) do
        [
          ActionController::Parameters.new({"id"=>"1", "quantity"=>"2"}),
          ActionController::Parameters.new({"id"=>"3", "quantity"=>"1"})
        ]
      end

      it 'returns a formatted list with additional information' do
        products = subject.execute

        expect(products).to match_array([
          {
            id: 1,
            quantity: 2,
            unit_amount: 15157,
            total_amount: 30314,
            discount: 0,
            is_gift: false
          },
          {
            id: 3,
            quantity: 1,
            unit_amount: 60356,
            total_amount: 60356,
            discount: 0,
            is_gift: false
          }
        ])
      end
    end
  end
end
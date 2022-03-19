#frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PurchaseResumeService', type: :service do
  describe 'execute' do
    subject { PurchaseResumeService.new(products) }

    context 'when it receives product params' do
      let(:products) do
        [
          {:id=>1, :quantity=>2, :unit_amount=>15157, :total_amount=>30314, :discount=>0, :is_gift=>false},
          {:id=>3, :quantity=>1, :unit_amount=>60356, :total_amount=>60356, :discount=>0, :is_gift=>false}
        ]
      end

      it 'returns the purchase resume' do
        purchase_resume = subject.execute

        expect(purchase_resume).to match({
          total_amount: 90670,
          total_amount_with_discount: 90670,
          total_discount: 0
        })
      end
    end
  end
end

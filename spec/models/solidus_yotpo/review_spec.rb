describe SolidusYotpo::Review, type: :model do
  let(:user) { create(:user) }
  let(:order) { create(:order_ready_to_ship, user: user) }
  let(:line_item) { order.line_items.first }
  let(:variant) { line_item.variant }
  let(:product) { variant.product }
  let(:review) { create(:review, product: product, user: user) }
  let(:store) { Spree::Store.default }

  describe '#to_payload' do
    let(:ship_method_name) { order.shipments.first.shipping_method.name }

    subject { review.to_payload }

    it 'returns a hash with review and associations data' do
      aggregate_failures 'review data' do
        expect(subject.values).to include(review.content, review.title, review.score)
      end

      aggregate_failures 'product data' do
        expect(subject.values).to include(product.name,  product.description, product.master.sku)
        expect(subject.dig(:product_metadata, :vendor)).to eq store.name
        expect(subject.dig(:product_metadata, :custom_properties, 0, :value)).to eq variant.sku
      end

      aggregate_failures 'order data' do
        expect(subject.dig(:order_metadata, :delivery_type)).to eq ship_method_name
        expect(subject.dig(:order_metadata, :custom_properties, 0, :value)).to eq order.number
      end

      aggregate_failures 'user data' do
        expect(subject.values).to include(user.email, order.bill_address.full_name)
        expect(subject).to have_key :customer_metadata
      end
    end
  end

  describe '#sync' do
    pending
  end
end

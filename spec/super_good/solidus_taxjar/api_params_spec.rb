require 'spec_helper'

RSpec.describe SuperGood::SolidusTaxJar::APIParams do
  let(:order) do
    Spree::Order.create!(
      item_total: 28.00,
      shipment_total: 3.01,
      store: store,
      ship_address: ship_address,
      line_items: [line_item]
    )
  end

  let(:store) do
    Spree::Store.create!(
      name: "Default Store",
      url: "https://store.example.com",
      code: "store",
      mail_from_address: "contact@example.com",
      cart_tax_country_iso: "US"
    )
  end

  let(:ship_address) do
    Spree::Address.create!(
      country: country_us,
      state: state_california,
      zipcode: "90210",
      city: "Los Angeles",
      address1: "475 N Beverly Dr",

      first_name: "Chuck",
      last_name: "Schuldiner",
      phone: "1-250-555-4444"
    )
  end

  let(:country_us) do
    Spree::Country.create!(
      iso_name: "UNITED STATES",
      iso: "US",
      iso3: "USA",
      name: "United States",
      numcode: 840,
      states_required: true
    )
  end

  let(:state_california) do
    Spree::State.create!(
      country: country_us,
      name: "California",
      abbr: "CA"
    )
  end

  let(:line_item) do
    Spree::LineItem.new(
      variant: variant,
      price: 10,
      quantity: 3,
      promo_total: -2
    )
  end

  let(:variant) do
    Spree::Variant.create!(
      product: product,
      price: 10
    )
  end

  let(:product) do
    Spree::Product.create!(
      name: "Product Name",
      shipping_category: shipping_category,
      tax_category: tax_category,
      master: master_variant,
      variants: [master_variant]
    )
  end

  let(:shipping_category) do
    Spree::ShippingCategory.create!(name: "Default Category")
  end

  let(:tax_category) do
    Spree::TaxCategory.create!(
      name: "Default",
      is_default: true,
      tax_code: "A_GEN_TAX"
    )
  end

  let(:master_variant) do
    Spree::Variant.new(
      is_master: true,
      price: 10
    )
  end

  describe "#order_params" do
    subject { described_class.order_params(order) }

    it "returns params for fetching the tax for the order" do
      expect(subject).to eq(
        to_country: "US",
        to_zip: "90210",
        to_city: "Los Angeles",
        to_state: "CA",
        to_street: "475 N Beverly Dr",

        shipping: 3.01,

        line_items: [{
          id: order.line_items.first.id,
          quantity: 3,
          unit_price: 10.00,
          discount: 2.00,
          product_tax_code: "A_GEN_TAX"
        }]
      )
    end
  end

  describe "#address_params" do
    subject { described_class.address_params(ship_address) }

    it "returns params for fetching the tax info for that address" do
      expect(subject).to eq([
        "90210",
        {
          city: "Los Angeles",
          country: "US",
          state: "CA",
          street: "475 N Beverly Dr"
        }
      ])
    end
  end
end
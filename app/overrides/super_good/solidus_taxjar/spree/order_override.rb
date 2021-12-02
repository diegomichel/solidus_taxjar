module SuperGood
  module SolidusTaxjar
    module Spree
      module OrderOverride
        def self.prepended(base)
          base.has_many :taxjar_order_transactions,
            class_name: "SuperGood::SolidusTaxjar::OrderTransaction",
            dependent: :destroy,
            inverse_of: :order
        end

        ::Spree::Order.prepend self
      end
    end
  end
end
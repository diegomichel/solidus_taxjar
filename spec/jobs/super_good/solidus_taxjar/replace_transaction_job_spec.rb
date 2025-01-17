require "spec_helper"

RSpec.describe SuperGood::SolidusTaxjar::ReplaceTransactionJob do
  describe ".perform_later" do
    subject { described_class.perform_later(order) }

    let(:order) { create :order }
    let(:mock_reporting) { instance_double ::SuperGood::SolidusTaxjar::Reporting }

    it "enqueues the job" do
      assert_enqueued_with(job: described_class, args: [order]) do
        subject
      end
    end

    it "replaces the transaction when it performs the job" do
      allow(SuperGood::SolidusTaxjar).to receive(:reporting).and_return(mock_reporting)
      expect(mock_reporting).to receive(:refund_and_create_new_transaction).with(order)

      perform_enqueued_jobs do
        subject
      end
    end
  end
end

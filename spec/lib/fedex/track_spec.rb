require 'spec_helper'

module Fedex
  describe TrackingInformation do
    let(:fedex) { Shipment.new(fedex_credentials) }

    context "shipments with tracking number", :vcr, :focus do
      let(:options) do
        { :package_id             => "771513950417",
          :package_type           => "TRACKING_NUMBER_OR_DOORTAG",
          :include_detailed_scans => true
        }
      end

      it "fails if using an invalid package type" do
        fail_options = options

        fail_options[:package_type] = "UNKNOWN_PACKAGE"

        expect { fedex.track(options) }.to raise_error
      end
    end

    context "duplicate shipments with same tracking number", :vcr, :focus do
      let(:options) do
        { :package_id             => "771054010426",
          :package_type           => "TRACKING_NUMBER_OR_DOORTAG",
          :include_detailed_scans => true
        }
      end

      it "should return tracking information for all shipments associated with tracking number" do
        tracking_info = fedex.track(options)

        expect(tracking_info.length).to be > 1
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe NodeApiClient do
  context '#get_file_list' do
    subject { NodeApiClient.new.get_file_list }

    context 'empty nodes' do
      it do
        VCR.use_cassette("get_file_list") do
          subject
        end
      end
    end
  end
end
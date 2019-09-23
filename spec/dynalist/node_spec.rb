# frozen_string_literal: true

RSpec.describe Node do
  context '#color' do
    subject { instance.color }
    let(:instance) { Node.new(color: 0) }

    it do
      is_expected.to eq(:white)
    end
  end

  context '#updated_at' do
    subject { instance.updated_at }
    let(:instance) { Node.new(modified: 1552959309804) }

    it do
      is_expected.to eq(Time.mktime(2019, 03, 19, 10, 35, 9, 804000))
    end
  end

  context '#updated_at' do
    subject { instance.updated_at }
    let(:instance) { Node.new(modified: 1552959335182) }

    it do
      is_expected.to eq(Time.mktime(2019, 03, 19, 10, 35, 35, 182000))
    end
  end
end

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

  context '#children' do
    subject { instance.children }
    before do
      NodeTree.add(instance)
      NodeTree.add(children)
    end
    let(:instance) { Node.new(children: [children.id]) }
    let(:children) { Node.new(id: 2) }

    it do
      is_expected.to eq([children])
    end
  end

  context '#include' do
    subject { instance.include(document_id: 1, id: id) }
    let(:instance) { Node.new(document_id: 1, id: 1) }

    context 'when find id' do
      let(:id) { 1 }
      it { is_expected.to be_truthy }
    end

    context 'when not find id' do
      let(:id) { 2 }
      it { is_expected.to be_falsey }
    end
  end
end

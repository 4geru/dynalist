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
      is_expected.to eq(Time.utc(2019, 03, 19, 01, 35, 9, 804000))
    end
  end

  context '#created_at' do
    subject { instance.created_at }
    let(:instance) { Node.new(created: 1552959335182) }

    it do
      is_expected.to eq(Time.utc(2019, 03, 19, 01, 35, 35, 182000))
    end
  end

  context '#children' do
    subject { instance.children }
    before do
      NodeTree.add(instance)
      NodeTree.add(children)
    end
    let(:instance) { Node.new(children: ['2']) }
    let!(:children) { Node.new(id: '2') }

    it do
      is_expected.to eq([children])
    end
  end

  context '#include' do
    subject { instance.include(file_id: 1, node_id: id) }
    let(:instance) { Node.new(file_id: 1, id: 1) }

    context 'when find id' do
      let(:id) { 1 }
      it { is_expected.to be_truthy }
    end

    context 'when not find id' do
      let(:id) { 2 }
      it { is_expected.to be_falsey }
    end
  end

  context '#attributes' do
    subject { instance.attributes }
    let(:instance) { Node.new() }

    it { expect(subject.keys).to match_array(%i[file_id node_id content note created modified children_ids checked checkbox heading color_number])}


  end
end

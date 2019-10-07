# frozen_string_literal: true

RSpec.describe NodeTree do
  before { NodeTree.clear }
  context '#initialize' do
    context 'empty nodes' do
      it { expect(NodeTree.nodes).to be_empty }
    end
  end

  context '.add' do
    before { NodeTree.clear }

    let(:instance) { NodeTree.instance }
    let(:nodes) { [Node.new, Node.new] }

    context 'empty nodes' do
      it { expect{ NodeTree.add(nodes) }.to change{ NodeTree.nodes.size }.from(0).to(2) }
    end
  end

  context '.find_by' do
    subject { NodeTree.find_by(file_id: 1, node_id: 1) }
    let(:instance) { NodeTree.instance }
    let(:node) { Node.new(file_id: 1, id: 1) }
    before do
      NodeTree.add([node])
    end

    context 'empty nodes' do
      it { is_expected.to eq(node) }
    end
  end

  context '.where' do
    let(:nodes) { [expected, dummy].flatten }
    before do
      NodeTree.add(nodes)
    end

    context 'when query is value' do
      subject { NodeTree.where(node_id: 1) }
      let(:expected) { [Node.new(id: 1)] }
      let(:dummy) { [Node.new(id: 2), Node.new(id: nil)] }
      it { is_expected.to eq(expected) }
    end

    context 'when query is array' do
      subject { NodeTree.where(node_id: [1, 2]) }
      let(:expected) { [Node.new(id: 1), Node.new(id: 2)] }
      let(:dummy) { [Node.new(id: 3), Node.new(id: nil)] }
      it { is_expected.to eq(expected) }
    end
  end
end

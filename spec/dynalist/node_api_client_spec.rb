# frozen_string_literal: true

RSpec.describe NodeApiClient do
  context '#read' do
    subject { NodeApiClient.new.read(document) }
    let(:document) { Document.new(id: 'DAz0fqDKo-dpEIhxMMHuPjG5') }

    it do
      VCR.use_cassette("document_read") do
        results = subject
        results.each do |result|
          expect(result).to be_a_kind_of Node
        end
        expect(NodeTree.nodes.count).to eq(2)
        expect(NodeTree.nodes.map(&:file_id).uniq).to eq [document.id]
      end
    end
  end

  context '#check_updates' do
    subject { NodeApiClient.new.check_updates(documents) }
    let(:documents) do
      [
        Document.new(id: 'DAz0fqDKo-dpEIhxMMHuPjG5'),
        Document.new(id: '7SVKDshb95STC1XpMrCkp_Mc'),
      ]
    end

    it do
      VCR.use_cassette("check_updates") do
        results = subject
        document_ids = documents.map(&:id)
        expect(results.keys).to match_array document_ids
        expect(results.count).to eq(documents.count)
      end
    end
  end

  describe 'Inside class' do
    describe 'Insert' do
      describe '#to_query' do
        subject { NodeApiClient::Insert.new(parent_node, node).to_query }
        let(:parent_node) { Node.new(id: 'root') }
        let(:node) { Node.new(content: 'content body') }

        it do
          is_expected.to eq(
            Node.new.attributes.merge({
              action: "insert",
              parent_id: parent_node.node_id,
              index: 0,
              content: node.content
            })
          )
        end
      end
    end

    describe 'Edit' do
      describe '#to_query' do
        subject { NodeApiClient::Edit.new(node).to_query }
        let(:node) { Node.new(id: 'iy2a5EscizQnqZZDWcCJW_g6', content: 'content body') }

        it do
          is_expected.to eq(
            Node.new.attributes.merge({
              action: "edit",
              node_id: node.node_id,
              content: node.content
            })
          )
        end
      end
    end

    describe 'Move' do
      describe '#to_query' do
        subject { NodeApiClient::Move.new(parent_node, node).to_query }
        let(:parent_node) { Node.new(id: 'root_id') }
        let(:node) { Node.new(id: 'iy2a5EscizQnqZZDWcCJW_g6', content: 'content body') }

        it do
          is_expected.to eq(
            {
              action: "move",
              parent_id: parent_node.node_id,
              node_id: node.node_id,
              index: 0
            }
          )
        end
      end
    end

    describe 'Delete' do
      describe '#to_query' do
        subject { NodeApiClient::Delete.new(node).to_query }
        let(:node) { Node.new(id: 'iy2a5EscizQnqZZDWcCJW_g6') }

        it do
          is_expected.to eq(
            {
              action: "delete",
              node_id: node.node_id
            }
          )
        end
      end
    end
  end
end
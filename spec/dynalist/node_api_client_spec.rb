# frozen_string_literal: true

RSpec.describe NodeApiClient do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('DYNALIST_TOKEN').and_return('TEST_DUMMY_TOKEN')
  end

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
        document_ids = documents.map{|d| d.id.to_sym }
        expect(results.keys).to match_array document_ids
        expect(results.count).to eq(documents.count)
      end
    end
  end

  context '#edit' do
    subject { NodeApiClient.new.edit(document, queries) }
    around(:example) do |example|
      VCR.use_cassette("document_#{query_name}") do
        example.run
      end
    end

    shared_context 'success to api request' do
      it { is_expected.to eql [] }
    end

    let(:document) { Document.new(id: 'DAz0fqDKo-dpEIhxMMHuPjG5') }
    let(:root_node) { Node.new(id: 'root') }

    context 'insert query' do
      let(:query_name) { 'insert' }
      let(:queries) do
        [ NodeApiClient::Insert.new(root_node, node) ]
      end

      let(:node) do
        Node.new(content: 'new content')
      end

      it { is_expected.not_to eql [] }
    end

    context 'edit query' do
      let(:query_name) { 'edit' }
      let(:queries) do
        [ NodeApiClient::Edit.new(node) ]
      end

      let(:node) do
        Node.new(id: '0KXgB-e3dRc-dpEPXCfHtoOW', checked: true, content: 'okok')
      end

      include_context 'success to api request'
    end

    context 'move query' do
      let(:query_name) { 'move' }
      let(:queries) do
        [ NodeApiClient::Move.new(root_node, node) ]
      end

      let(:node) do
        Node.new(id: 'mQkeYMwEjRf9PTyJkUddVuN1', checked: true)
      end

      include_context 'success to api request'
    end

    context 'delete query' do
      let(:query_name) { 'delete' }
      let(:queries) do
        [ NodeApiClient::Delete.new(node) ]
      end

      let(:node) do
        Node.new(id: 'SDNpEM7h6HMwNu57MQvdkFxL')
      end

      include_context 'success to api request'
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
        let(:query_name) { 'mew' }
        let(:queries) do
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
    end

    describe 'Delete' do
      describe '#to_query' do
        let(:query_name) { 'mew' }
        let(:queries) do
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
end
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
end
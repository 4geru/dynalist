# frozen_string_literal: true

RSpec.describe FileApiClient do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('DYNALIST_TOKEN').and_return('TEST_DUMMY_TOKEN')
  end

  context '#get_file' do
    subject { FileApiClient.new.get_file }

    context 'empty nodes' do
      it do
        VCR.use_cassette("get_file") do
          expect(subject.count).to eq 2
          expect(FileTree.instance.files.count).to eq 2
          expect(subject[0]).to be_a_kind_of Document
          expect(subject[1]).to be_a_kind_of Folder
          expect(FileTree.where(type: 'document').count).to eq 1
          expect(FileTree.where(type: 'folder').count).to eq 1
        end
      end
    end
  end

  context '#move_file' do
    subject { FileApiClient.new.move_file(queries) }
    let(:queries) do
      [
        FileApiClient::Edit.new(document, 'document01'),
        FileApiClient::Move.new(document, root)
      ]
    end
    let(:document) { Document.new(id: 'document01_id', type: 'document') }
    let(:root) { Folder.new(id: 'root_id', type: 'folder') }


    context 'empty nodes' do
      it do
        VCR.use_cassette("move_file") do
          expect(subject).to eq [true, true]
        end
      end
    end
  end

  describe 'Inside class' do
    describe 'Edit' do
      describe '#to_query' do
        subject { FileApiClient::Edit.new(document, 'document01').to_query }
        let(:document) { Document.new(id: 'document01_id', type: 'document') }

        it do
          is_expected.to eq({
            action: "edit",
            type: document.type,
            file_id: document.id,
            title: 'document01'
          })
        end
      end
    end

    describe 'Move' do
      describe '#to_query' do
        subject { FileApiClient::Move.new(document, root).to_query }
        let(:document) { Document.new(id: 'document01_id', type: 'document') }
        let(:root) { Folder.new(id: 'root_id', type: 'folder') }

        it do
          is_expected.to eq({
            action: "move",
            type: document.type,
            file_id: document.id,
            parent_id: root.id,
            index: 0
          })
        end
      end
    end
  end
end
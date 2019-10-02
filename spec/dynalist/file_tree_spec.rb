# frozen_string_literal: true

RSpec.describe FileTree do
  before { FileTree.clear }
  context '#initialize' do
    let(:instance) { FileTree.instance }

    context 'empty children' do
      it { expect(instance.files).to be_empty }
    end
  end

  context '.add' do
    before { FileTree.clear }

    let(:instance) { FileTree.instance }
    let(:files) { [Folder.new, Folder.new] }

    context 'empty folders' do
      it { expect{ FileTree.add(files) }.to change{ FileTree.instance.files.size }.from(0).to(2) }
    end
  end

  context '.find_by' do
    subject { FileTree.find_by(id: 1) }
    let(:instance) { FileTree.instance }
    let(:files) { Folder.new(id: 1) }
    before do
      FileTree.add([files])
    end

    context 'empty folders' do
      it { is_expected.to eq(files) }
    end
  end

  context '.where' do
    let(:files) { [expected, dummy].flatten }
    before do
      FileTree.add(files)
    end

    context 'when query is value' do
      subject { FileTree.where(id: 1) }
      let(:expected) { [Folder.new(id: 1)] }
      let(:dummy) { [Folder.new(id: 2), Folder.new(id: nil)] }
      it { is_expected.to eq(expected) }
    end

    context 'when query is array' do
      subject { FileTree.where(id: [1, 2]) }
      let(:expected) { [Folder.new(id: 1), Folder.new(id: 2)] }
      let(:dummy) { [Folder.new(id: 3), Folder.new(id: nil)] }
      it { is_expected.to eq(expected) }
    end
  end
end

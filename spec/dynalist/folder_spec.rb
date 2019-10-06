# frozen_string_literal: true

RSpec.describe Folder do
  describe "Initialize" do
    context 'delegate to parent class' do
      subject { instance }
      let(:instance) { Folder.new(id: 1, title: 'folder_title', type: 'folder', permission: 1) }
      it { expect(subject.id).to eq 1 }
      it { expect(subject.title).to eq 'folder_title' }
      it { expect(subject.type).to eq 'folder' }
      it { expect(subject.permission).to eq :read_only }
    end
  end

  describe 'Instance Methods' do
    describe '#collapsed?' do
      subject { instance.collapsed? }
      let(:instance) { Folder.new(collapsed: collapsed) }
      context 'when true' do
        let(:collapsed) { true }
        it { is_expected.to eq true }
      end

      context 'when false' do
        let(:collapsed) { false }
        it { is_expected.to eq false }
      end
    end

    context '#children' do
    subject { instance.children }
    before do
      FileTree.add(instance)
      FileTree.add(children)
    end
    let(:instance) { Folder.new(children: [children.id]) }
    let(:children) { Folder.new(id: 2) }

    it do
      is_expected.to eq([children])
    end
  end
  end
end

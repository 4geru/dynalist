# frozen_string_literal: true

RSpec.describe Document do
  describe "Initialize" do
    context 'delegate to parent class' do
      subject { instance }
      let(:instance) { Document.new(id: 1, title: 'document_title', type: 'document', permission: 1) }
      it { expect(subject.id).to eq 1 }
      it { expect(subject.title).to eq 'document_title' }
      it { expect(subject.type).to eq 'document' }
      it { expect(subject.permission).to eq :read_only }
    end
  end
end

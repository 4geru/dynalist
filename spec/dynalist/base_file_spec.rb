# frozen_string_literal: true

RSpec.describe BaseFile do
  context '#permission' do
    subject { instance.permission }
    let(:instance) { BaseFile.new(permission: permission_number) }

    context 'when no_access' do
      let(:permission_number) { 0 }
      it { is_expected.to eq(:no_access) }
    end

    context 'when read_only' do
      let(:permission_number) { 1 }
      it { is_expected.to eq(:read_only) }
    end

    context 'when edit_rights' do
      let(:permission_number) { 2 }
      it { is_expected.to eq(:edit_rights) }
    end

    context 'when manage' do
      let(:permission_number) { 3 }
      it { is_expected.to eq(:manage) }
    end

    context 'when owner' do
      let(:permission_number) { 4 }
      it { is_expected.to eq(:owner) }
    end
  end

end

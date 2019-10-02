# frozen_string_literal: true

class Document < BaseFile
  def initialize(id: nil, title: nil, type: nil, permission: nil)
    super(id: id, title: title, type: 'document', permission: permission)
  end
end

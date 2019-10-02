# frozen_string_literal: true

class Folder < BaseFile
  def initialize(id: nil, title: nil, type: nil, permission: nil, collapsed: false, children: [])
    @collapsed = collapsed
    @children_ids = children
    super(id: id, title: title, type: 'folder', permission: permission)
  end

  def collapsed?
    @collapsed
  end
end

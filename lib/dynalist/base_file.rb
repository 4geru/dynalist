# frozen_string_literal: true

class BaseFile
  PERMISSION = {
    0 => :no_access,
    1 => :read_only,
    2 => :edit_rights,
    3 => :manage,
    4 => :owner
  }

  attr_reader :id, :title, :type

  def initialize(id: nil, title: nil, type: nil, permission: nil)
    @id = id
    @title = title
    @type = type
    @permission_number = permission
  end

  def permission
    PERMISSION[@permission_number]
  end

  def include(**query)
    query.each do |key, value|
      next if instance_variable_get("@#{key}") == value
      return false
    end

    return true
  end
end

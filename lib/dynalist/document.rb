# frozen_string_literal: true

class Document < BaseFile
  def initialize(id: nil, title: nil, type: nil, permission: nil)
    super(id: id, title: title, type: 'document', permission: permission)
  end

  def attributes
    instance_variables.map do |key|
      [key[1..-1].to_sym, instance_variable_get(key)]
    end.to_h
  end
end

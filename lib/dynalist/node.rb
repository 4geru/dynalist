# frozen_string_literal: true

class Node
  COLOR = {
    0 => :white,
    1 => :red,
    2 => :orange,
    3 => :yellow,
    4 => :green,
    5 => :blue,
    6 => :purple
  }.freeze

  attr_reader :file_id, :node_id, :content, :note, :children, :checked, :checkbox, :heading

  def initialize(file_id: nil, id: nil, content: nil, note: nil, created: nil, modified: nil, children: [], checked: false, checkbox: false, heading: 0, color: 0)
    @file_id = file_id
    @node_id = id
    @content = content
    @note = note
    @created = created
    @modified = modified
    @children_ids = children
    @checked = checked
    @checkbox = checkbox
    @heading = heading
    @color_number = color
  end

  def include(**query)
    query.each do |key, value|
      next if instance_variable_get("@#{key}") == value
      return false
    end

    return true
  end

  def color
    COLOR[@color_number]
  end

  def updated_at
    to_time(@modified)
  end

  def created_at
    to_time(@created)
  end

  def children
    NodeTree.where(node_id: @children_ids)
  end

  def attributes
    instance_variables.map do |key|
      [key[1..-1].to_sym, instance_variable_get(key)]
    end.to_h
  end

  private

  def to_time(time)
    Time.at(time / 1000, time % 1000 * 1000).utc
  end
end
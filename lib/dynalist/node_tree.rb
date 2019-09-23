# frozen_string_literal: true

require 'singleton'

class NodeTree
  include Singleton

  @@nodes = []

  def nodes
    @@nodes
  end

  def self.clear
    @@nodes = []
  end

  def self.add(nodes)
    @@nodes << nodes
    @@nodes.flatten!
  end

  def self.find_by(**query)
    @@nodes.find { |node| node.include(**query) }
  end

  def self.where(**query)
    @@nodes.select do |node|
      query.all? do |key, value|
        if value.kind_of? Array
          value.any? { |v| node.include(**{key => v}) }
        else
          p node.include(**{key => value})
          node.include(**{key => value})
        end
      end
    end
  end
end

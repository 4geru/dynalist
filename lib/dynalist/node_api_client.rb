# frozen_string_literal: true
require 'json'

class NodeApiClient < BaseApiClient
  def read(document)
    res = @conn.post "#{@base}doc/read", {token: @token, file_id: document.id}.to_json
    JSON.parse(res.body, symbolize_names: true)[:nodes].map{ |node| node }
    nodes = JSON.parse(res.body, symbolize_names: true)[:nodes].map{ |node| Node.new(node.merge(file_id: document.id)) }
    NodeTree.add(nodes)
  end

  def check_updates(documents)
    document_ids = documents.map(&:id)
    res = @conn.post "#{@base}doc/check_for_updates", {token: @token, file_ids: document_ids}.to_json
    JSON.parse(res.body, symbolize_names: true)[:versions]
  end

  def edit(document, queries)
    changes = queries.map(&:to_query)
    res = @conn.post "#{@base}doc/edit", {token: @token, file_id: document.id, changes: changes}.to_json
    JSON.parse(res.body, symbolize_names: true)[:new_node_ids]
  end

  class Insert
    def initialize(parent_node, node, index = 0)
      @parent_node = parent_node
      @node = node
      @index = index
    end

    def to_query
      {
        action: "insert",
        parent_id: @parent_node.node_id,
        index: @index
      }.merge(@node.attributes)
    end
  end

  class Edit
    def initialize(node)
      @node = node
    end

    def to_query
      {
        action: "edit",
        node_id: @node.node_id
      }.merge(@node.attributes)
    end
  end

  class Move
    def initialize(parent_node, node, index = 0)
      @parent_node = parent_node
      @node = node
      @index = index
    end

    def to_query
      {
        action: "move",
        parent_id: @parent_node.node_id,
        node_id: @node.node_id,
        index: @index
      }
    end
  end

  class Delete
    def initialize(node)
      @node = node
    end

    def to_query
      {
        action: "delete",
        node_id: @node.node_id
      }
    end
  end
end

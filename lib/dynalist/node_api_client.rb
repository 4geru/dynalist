# frozen_string_literal: true
require 'json'

class NodeApiClient < BaseApiClient
  def read(document)
    res = @conn.post "#{@base}doc/read", {token: @token, file_id: document.id}.to_json
    JSON.parse(res.body, symbolize_names: true)[:nodes].map{ |node| node }
    nodes = JSON.parse(res.body, symbolize_names: true)[:nodes].map{ |node| Node.new(node.merge(file_id: document.id)) }
    NodeTree.add(nodes)
  end
end

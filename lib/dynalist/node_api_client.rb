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
    JSON.parse(res.body)['versions']
  end
end

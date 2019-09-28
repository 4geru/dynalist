# frozen_string_literal: true
require 'json'

class NodeApiClient < BaseApiClient
  def get_file_list
    @conn.post "#{@base}file/list", {token: @token}.to_json
  end
end

# frozen_string_literal: true
require 'json'
require 'pry'

class FileApiClient < BaseApiClient
  def get_file_list
    response = @conn.post "#{@base}file/list", {token: @token}.to_json
    json = JSON.parse(response.body, symbolize_names: true)
    FileTree.instance.root_id = json[:root_file_id]
    json[:files].each do |file|
      instance = if file[:type] == 'folder'
          Folder.new(file)
        else
          Document.new(file)
        end
      FileTree.add(instance)
    end
  end
end

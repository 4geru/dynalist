# frozen_string_literal: true
require 'json'

class FileApiClient < BaseApiClient
  def get_file
    response = @conn.post "#{@base}file/list", {token: @token}.to_json
    check_response!(response)
    json = JSON.parse(response.body, symbolize_names: true)

    FileTree.instance.root_id = json[:root_file_id]
    json[:files].map do |file|
      instance = if file[:type] == 'folder'
          Folder.new(file)
        else
          Document.new(file)
        end
      FileTree.add(instance)

      instance
    end
  end

  def move_file(queries)
    changes = queries.map(&:to_query)
    response = @conn.post "#{@base}file/edit", {token: @token, changes: changes}.to_json
    check_response!(response)
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  class Edit
    def initialize(file, title)
      @file = file
      @title = title
    end

    def to_query
      {
        action: "edit",
        type: @file.type,
        file_id: @file.id,
        title: @title
      }
    end
  end

  class Move
    def initialize(file, parent_file, index: 0)
      @file = file
      @parent_file = parent_file
      @index = index
    end

    def to_query
      {
        action: "move",
        type: @file.type,
        file_id: @file.id,
        parent_id: @parent_file.id,
        index: @index
      }
    end
  end
end

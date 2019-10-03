# frozen_string_literal: true

require 'singleton'

class FileTree
  include Singleton

  @@files = []
  @@root_id = nil

  def root_id=(root_id)
    @@root_id = root_id
  end

  def root_id
    @@root_id
  end

  def files
    @@files
  end

  def self.clear
    @@files = []
  end

  def self.add(files)
    @@files << files
    @@files.flatten!
  end

  def self.find_by(**query)
    @@files.find { |file| file.include(**query) }
  end

  def self.where(**query)
    @@files.select do |file|
      query.all? do |key, value|
        if value.kind_of? Array
          value.any? { |v| file.include(**{key => v}) }
        else
          file.include(**{key => value})
        end
      end
    end
  end
end

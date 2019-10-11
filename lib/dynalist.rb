require 'faraday'

require "dynalist/version"
require "dynalist/node"
require "dynalist/node_tree"
require "dynalist/base_file"
require "dynalist/file_tree"
require "dynalist/document"
require "dynalist/folder"
require "dynalist/base_api_client"
require "dynalist/file_api_client"
require "dynalist/node_api_client"

require "dotenv"
Dotenv.load

module Dynalist
  class Error < StandardError; end
end

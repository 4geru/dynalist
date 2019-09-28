# frozen_string_literal: true
require 'json'

class BaseApiClient
  def initialize
    @conn = Faraday.new(:url => 'https://dynalist.io/')
    @base = 'api/v1/'
    @token = ENV['TOKEN']
  end
end

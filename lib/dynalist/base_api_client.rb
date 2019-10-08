# frozen_string_literal: true
require 'json'

class BaseApiClient
  def initialize(token = nil)
    @conn = Faraday.new(:url => 'https://dynalist.io/')
    @base = 'api/v1/'
    @token = token || ENV['DYNALIST_TOKEN']
  end
end

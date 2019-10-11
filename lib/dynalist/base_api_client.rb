# frozen_string_literal: true
require 'json'

class BaseApiClient
  def initialize(token = nil)
    @conn = Faraday.new(:url => 'https://dynalist.io/')
    @base = 'api/v1/'
    @token = token || ENV['DYNALIST_TOKEN']
  end

  class Error < StandardError; end

  class ApiError < Error
    attr_reader :response

    # @param [Response] response
    def initialize(response = nil)
      @response = response
    end

    def message
      @response[:_msg]
    end
  end

  class InvalidError < ApiError; end
  class InvalidTokenError < ApiError; end
  class TooManyRequestsError < ApiError; end
  class LockFailError < ApiError; end

  ApiErrors = {
    Invalid: InvalidError,
    InvalidToken: InvalidTokenError,
    TooManyRequests: TooManyRequestsError,
    LockFail: LockFailError
  }.freeze

  def check_response!(response)
    res = JSON.parse(response.body, symbolize_names: true)
    return true if res[:_code] == 'Ok'

    error = ApiErrors.fetch(res[:_code].to_sym, ApiError)
    raise error, res
  end
end

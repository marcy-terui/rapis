require 'aws-sdk'

module Rapis
  class Client
    def initialize
      @api = Aws::APIGateway::Client.new
    end

    def get_apis(pos=nil)
      opt = {}
      opt[:limit] = 500
      opt[:position] = pos unless pos.nil?

      ret = @api.get_rest_apis(opt)
      ret.items.concat(get_apis(ret.posision)) unless ret.position.nil?
      ret.items
    end

    def get_resources(api_id, pos=nil)
      opt = {}
      opt[:rest_api_id] = api_id
      opt[:limit] = 500
      opt[:position] = pos unless pos.nil?

      ret = @api.get_resources(opt)
      ret.items.concat(get_resources(api_id, ret.posision)) unless ret.position.nil?
      ret.items
    end
  end
end

require 'rapis/client'
require 'rapis/action/export'

module Rapis
  class Actions
    def initialize
      @client = Rapis::Client.new
    end

    include Rapis::Action::Export
  end
end

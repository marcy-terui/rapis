require 'thor'
require 'rapis/actions'

module Rapis
  class Cli < Thor
    def initialize(*args)
      @actions = Rapis::Actions.new
      super(*args)
    end

    desc "hello NAME", "say hello to NAME"
    def export
      @actions.export
    end
  end
end

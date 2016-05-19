require 'thor'
require 'rapis/actions'

module Rapis
  class Cli < Thor
    class_option :file, aliases: '-f', desc: 'Configuration file', type: :string, default: 'Apifile'

    def initialize(*args)
      @actions = Rapis::Actions.new
      super(*args)
    end

    desc "create", "Create REST API"
    option :description, aliases: '-d', desc: 'Description', type: :string, default: ''
    def create(name)
      @actions.create(name, options)
    end

    desc "convert", "Convert the REST API configuration to the specified format"
    option :format, aliases: '-F', desc: 'Output format # accepts json, yaml', type: :string, required: true
    option :output, aliases: '-o', desc: 'Output path', type: :string, default: ''
    def convert
      @actions.convert(options)
    end

    desc "list", "List the REST APIs and the stages"
    option :verbose, aliases: '-V', desc: 'Verbose mode', type: :boolean, default: false
    def list
      @actions.list(options)
    end

    desc "export", "Export the configuration as Ruby DSL"
    option :rest_api, aliases: '-r', desc: 'The id of the REST API', type: :string, required: true
    option :stage, aliases: '-s', desc: 'The name of the stage', type: :string, required: true
    option :write, aliases: '-w', desc: 'Write the configuration to the file', type: :boolean, default: false
    def export
      @actions.export(options)
    end

    desc "diff", "Diff the local configuration and the remote configuration"
    option :rest_api, aliases: '-r', desc: 'The id of the REST API', type: :string, required: true
    option :stage, aliases: '-s', desc: 'The name of the stage', type: :string, required: true
    def diff
      @actions.diff(options)
    end

    desc "apply", "Apply the REST API configuration"
    option :rest_api, aliases: '-r', desc: 'The id of the REST API', type: :string, required: true
    def apply
      @actions.apply(options)
    end

    desc "deploy", "Deploy the current REST API configuration to the stage"
    option :rest_api, aliases: '-r', desc: 'The id of the REST API', type: :string, required: true
    option :stage, aliases: '-s', desc: 'The name of the stage', type: :string, required: true
    option :description, aliases: '-d', desc: 'The description for the deployment', type: :string, default: ''
    option :stage_description, aliases: '-D', desc: 'The description of the stage', type: :string, default: ''
    option :cache, aliases: '-c', desc: 'Size of the cache cluster # accepts 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118, 237', type: :string, default: '0.0'
    option :variables, aliases: '-v', desc: 'A map that defines the stage variables', type: :hash, default: {}
    def deploy
      @actions.deploy(options)
    end
  end
end

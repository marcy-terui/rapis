module Rapis
  class Cli < Thor
    class_option :file, aliases: '-f', desc: 'Configuration file', type: :string, default: 'Apifile'

    def self.start(*args)
      begin
        super(*args)
      rescue OperationError => e
        Rapis.logger.fatal(e.message)
      rescue => e
        Rapis.logger.error(e.message, e.backtrace)
      end
    end

    desc 'create', 'Create REST API'
    option :name, aliases: '-n', desc: 'Name', type: :string, required: true
    option :description, aliases: '-d', desc: 'Description', type: :string, default: nil
    def create
      actions.create(options)
    end

    desc 'convert', 'Convert the REST API configuration to the specified format'
    option :format, aliases: '-F', desc: 'Output format # accepts json, yaml', type: :string, required: true
    option :output, aliases: '-o', desc: 'Output path', type: :string, default: ''
    def convert
      actions.convert(options)
    end

    desc 'list', 'List the REST APIs and the stages'
    option :verbose, aliases: '-V', desc: 'Verbose mode', type: :boolean, default: false
    def list
      actions.list(options)
    end

    desc 'export', 'Export the configuration as Ruby DSL'
    option :rest_api, aliases: '-r', desc: 'The id of the REST API', type: :string, required: true
    option :stage, aliases: '-s', desc: 'The name of the stage', type: :string, required: true
    option :write, aliases: '-w', desc: 'Write the configuration to the file', type: :boolean, default: false
    def export
      actions.export(options)
    end

    desc 'diff', 'Diff the local configuration and the remote configuration'
    option :rest_api, aliases: '-r', desc: 'The id of the REST API', type: :string, required: true
    option :stage, aliases: '-s', desc: 'The name of the stage', type: :string, required: true
    def diff
      actions.diff(options)
    end

    desc 'apply', 'Apply the REST API configuration'
    option :rest_api, aliases: '-r', desc: 'The id of the REST API', type: :string, required: true
    def apply
      actions.apply(options)
    end

    desc 'deploy', 'Deploy the current REST API configuration to the stage'
    option :rest_api, aliases: '-r', desc: 'The id of the REST API', type: :string, required: true
    option :stage, aliases: '-s', desc: 'The name of the stage', type: :string, required: true
    option :description, aliases: '-d', desc: 'The description for the deployment', type: :string, default: ''
    option :stage_description, aliases: '-D', desc: 'The description of the stage', type: :string, default: ''
    option :cache, aliases: '-c', desc: 'Size of the cache cluster', type: :string, default: '0.0'
    option :variables, aliases: '-v', desc: 'A map that defines the stage variables', type: :hash, default: {}
    def deploy
      actions.deploy(options)
    end

    private

    def actions
      Rapis::Actions.new(
        Rapis::Client.new
      )
    end
  end
end

require 'yaml'
require 'json'
require 'rapis/client'
require 'rapis/converter'
require 'rapis/logger'
require 'rapis/utils'

module Rapis
  class Actions
    include Rapis::Logger::Helper

    def initialize
      @client = Rapis::Client.new
      @converter = Rapis::Converter.new
    end

    def create(name, options)
      ret = @client.create(name, options['description'])
      info("API id: #{ret.id}")
      info("API name: #{ret.name}")
      info("API description: #{ret.description}")
      ret.warnings.each {|w| warn("WARNING: #{w}") } unless ret.warnings.nil?
    end

    def convert(options)
      output = @converter.to_h(File.read(options['file']))
      case options['format']
      when 'json'
        output = JSON.pretty_generate(output)
        Rapis::Utils.print_json(output)
      when 'yaml'
        output = YAML.dump(output)
        Rapis::Utils.print_yaml(output)
      else
        raise "\"#{options['format']}\" format is not supported."
      end
      File.write(options['output'], output) unless options['output'].empty?
    end

    def list(options)
      @client.get_apis.each do |a|
        if options['verbose']
          api = Rapis::Utils.struct_to_hash(a)
          api['stages'] = []
        else
          a_key = "#{a.id} (#{a.name})"
          api = {a_key => []}
        end

        @client.get_stages(a.id).each do |s|
          if options['verbose']
            api['stages'] << Rapis::Utils.struct_to_hash(s)
          else
            api[a_key] = s.stage_name
          end
        end
        Rapis::Utils.print_yaml(YAML.dump(api))
      end
    end

    def export(options)
      dsl = @converter.to_dsl(
        @client.export_api(options['rest_api'], options['stage'])
      )
      Rapis::Utils.print_ruby(dsl)
      File.write(options['file'], dsl) if options['write']
    end

    def diff(options)
      puts Rapis::Utils.diff(
        @client.export_api(options['rest_api'], options['stage']),
        @converter.to_h(File.read(options['file']))
      )
    end

    def apply(options)
      ret = @client.put_api(
        options['rest_api'],
        @converter.to_h(File.read(options['file']))
      )
      info("Applied the REST API configuration to \"#{ret.id}\" (#{ret.name})")
      ret.warnings.each {|w| warn("WARNING: #{w}") } unless ret.warnings.nil?
    end

    def deploy(options)
      args = {}
      args[:rest_api_id] = options['rest_api']
      args[:stage_name] = options['stage']
      args[:description] = options['description'] unless options['description'].empty?
      args[:stage_description] = options['stage_description'] unless options['description'].empty?
      args[:cache_cluster_enabled] = (options['cache'].to_f > 0.0)
      args[:cache_cluster_size] = options['cache'] if args[:cache_cluster_enabled]
      args[:variables] = options['variables'] unless options['variables'].empty?

      ret = @client.deploy(args)
      summary = YAML.dump(Rapis::Utils.struct_to_hash(ret.api_summary))
      info("Deployment id: #{ret.id}")
      info("Deployment description: #{ret.description}")
      info("API summary :\n#{summary}")
    end
  end
end

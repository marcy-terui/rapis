module Rapis
  class Client
    def api
      Aws::APIGateway::Client.new
    end

    def create(name, desc)
      opt = {}
      opt[:name] = name
      opt[:description] = desc unless desc.nil?
      api.create_rest_api(opt)
    end

    def get_apis(pos = nil)
      opt = {}
      opt[:limit] = 500
      opt[:position] = pos unless pos.nil?

      ret = api.get_rest_apis(opt)
      ret.items.concat(get_apis(ret.posision)) unless ret.position.nil?
      ret.items
    end

    def get_stages(api_id)
      api.get_stages(rest_api_id: api_id).item
    end

    def export_api(api_id, stage_name)
      ret = api.get_export(
        rest_api_id: api_id,
        stage_name: stage_name,
        export_type: 'swagger',
        parameters: { extensions: 'integrations' }
      )

      JSON.load(ret.body.read)
    end

    def put_api(api_id, data)
      api.put_rest_api(
        rest_api_id: api_id,
        mode: 'overwrite',
        parameters: { extensions: 'integrations' },
        body: JSON.dump(data)
      )
    end

    def deploy(args)
      api.create_deployment(args)
    end
  end
end

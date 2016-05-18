require 'dslh'
require 'rapis/utils'

module Rapis
  module Action
    module Export
      def export
        key_conv = proc do |k|
          k = k.to_s
        end

        get_config.each do |id, api|
          dsl = Dslh.deval(api, key_conv: key_conv)
          dsl.gsub!(/^/, '  ').strip!
          puts <<-EOS
rest_api "#{id}" do
  #{dsl}
end
EOS
        end
      end

      def get_config
        confs = {}
        apis = @client.get_apis
        apis.each do |api|
          api = Rapis::Utils.struct_to_hash(api)
          resources = @client.get_resources(api[:id])
          resources = Rapis::Utils.struct_to_hash(resources)
          resources.map {|r| r.delete(:parent_id) }
          api[:resources] = resources
          id = api[:id]
          api.delete(:id)
          api.delete(:created_date)
          confs[id] = api
        end
        confs
      end
    end
  end
end

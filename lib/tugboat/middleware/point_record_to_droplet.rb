module Tugboat
  module Middleware
    class PointRecordToDroplet < Base
      def call(env)
        ocean = env["ocean"]

        droplet = ocean.droplets.find id: env["droplet_id"]

        if droplet.status == "active"
          status_color = GREEN
        else
          status_color = RED
        end

        domain = ocean.domains.find( name: env["user_domain"] )
        record = ocean.domain_records.find( for_domain: env["user_domain"], id: env["user_record_id"] )

        say "Pointing #{droplet.name} (#{droplet.public_ip}) to #{record.name}.#{domain.name}", nil, true

        record.data = droplet.public_ip
        record.type = 'A'

        ocean.domain_records.update( record, for_domain: env["user_domain"], id: env["user_record_id"] )

        say "done", :green, true
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end

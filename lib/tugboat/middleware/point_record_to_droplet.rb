module Tugboat
  module Middleware
    class PointRecordToDroplet < Base
      def call(env)
        ocean = env["ocean"]

        req = ocean.droplets.show env["droplet_id"]

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        droplet = req.droplet

        if droplet.status == "active"
          status_color = GREEN
        else
          status_color = RED
        end

        req = ocean.domains.show( env["user_domain_id"] )

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        domain = req.domain

        req = ocean.domains.show_record( env["user_domain_id"], env["user_record_id"] )

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        record = req.record

        say "Pointing #{droplet.name} (#{droplet.ip_address}) to #{record.name}.#{domain.name}", nil, true

        req = ocean.domains.edit_record( env["user_domain_id"], env["user_record_id"], :record_type => 'A', :data => droplet.ip_address )
        if req.status != "OK"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        say "done", :green, true
      end
    end
  end
end

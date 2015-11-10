module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base
      def call(env)
        ocean = env["ocean"]

        droplet_list = ocean.droplets.all

        if droplet_list.count == 0
          say "You don't appear to have any droplets.", :red
          say "Try creating one with #{GREEN}\`tugboat create\`#{CLEAR}"
        else
          droplet_list.each do |droplet|

            if droplet.private_ip
              private_ip = ", private_ip: #{droplet.private_ip}"
            end

            if droplet.status == "active"
              status_color = GREEN
            else
              status_color = RED
            end

            say "#{droplet.name} (ip: #{droplet.public_ip}#{private_ip}, status: #{status_color}#{droplet.status}#{CLEAR}, region: #{droplet.region.slug}, id: #{droplet.id})"
          end
        end

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


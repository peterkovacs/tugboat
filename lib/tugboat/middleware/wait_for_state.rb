module Tugboat
  module Middleware
    class WaitForState < Base
      def call(env)
        ocean = env["ocean"]

        say "Waiting for droplet to become #{env["user_droplet_desired_state"]}.", nil, false

        start_time = Time.now

        droplet = ocean.droplets.find id: env["droplet_id"]

        say ".", nil, false
        while droplet.status != env["user_droplet_desired_state"] do
          sleep 2
          droplet = ocean.droplets.find id: env["droplet_id"]
          say ".", nil, false
        end

        total_time = (Time.now - start_time).to_i

        say "done#{CLEAR} (#{total_time}s)", :green

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


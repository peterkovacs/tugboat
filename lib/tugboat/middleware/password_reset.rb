module Tugboat
  module Middleware
    class PasswordReset < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing password reset for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
        ocean.droplets.password_reset droplet_id: env["droplet_id"]

        say "done", :green
        say "Your new root password will be emailed to you"

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


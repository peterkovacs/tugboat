module Tugboat
  module Middleware
    class ListSSHKeys < Base
      def call(env)

        ocean = env["ocean"]
        ssh_keys = ocean.ssh_keys.all

        say "SSH Keys:"
        ssh_keys.each do |key|
          say "#{key.name} (id: #{key.id})"
        end

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


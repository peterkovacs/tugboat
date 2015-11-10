module Tugboat
  module Middleware
    class ListDomains < Base
      def call(env)
        ocean = env["ocean"]

        domains = ocean.domains.all

        if domains.count == 0
          say "No domains found"
        else
          domains.each do |domain|
            say domain.name, nil, true
          end
        end
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end

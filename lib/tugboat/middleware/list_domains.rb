module Tugboat
  module Middleware
    class ListDomains < Base
      def call(env)
        ocean = env["ocean"]

        domains = ocean.domains.list

        if domains.status != "OK"
          say "#{domains.status}: #{domains.error_message}", :red
          exit 1
        end
          
        domains = domains.domains

        if domains.empty?
          say "No domains found"
        else
          domains.each do |domain|
            say "#{domain.name} (id: #{domain.id}) #{domain.error}", nil, true
          end
        end
      end
    end
  end
end

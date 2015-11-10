module Tugboat
  module Middleware
    class DomainRecords < Base
      def call(env)
        ocean = env["ocean"]

        records = ocean.domain_records.all( for_domain: env["user_domain"] )
        if records.count < 1
          say "No records found"
        else
          records.each do |record|
            say "#{record.type} #{record.name} #{record.data} (id: #{record.id})", nil, true
          end
        end
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end

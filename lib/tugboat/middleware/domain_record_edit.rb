module Tugboat
  module Middleware
    class DomainRecordEdit < Base
      def call(env)
        ocean = env["ocean"]

        domain_record = ocean.domain_records.find( for_domain: env["user_domain"], id: env["user_record_id"] )
        domain_record.type = env["user_record_type"]
        domain_record.data = env["user_record_data"]

        begin
          ocean.domain_records.update( domain_record, for_domain: env["user_domain"], id: env["user_record_id"] )
          say "done", :green
        rescue DropletKit::Error => e
          say "#{e.message}", :red
          exit 1
        end
      end
    end
  end
end

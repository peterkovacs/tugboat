module Tugboat
  module Middleware
    class DomainRecords
      def call(env)
        ocean = env["ocean"]

        records = ocean.domains.list_records( env["user_domain_id"] )

        if records.status != "OK"
          say "#{records.status}: #{records.error_message}", :red
          exit 1
        end

        records = records.records
        if records.empty?
          say "No records found"
        else
          records.each do |record|
            say "#{record.record_type} #{record.name} #{record.data} (id: #{record.id})", nil, true
          end
        end
      end
    end
  end
end

module Tugboat
  module Middleware
    class DomainRecordEdit < Base
      def call(env)
        ocean = env["ocean"]

        req = ocean.domains.edit_record( env["user_domain_id"], env["user_record_id"], :record_type => env["user_record_type"], :data => env["user_record_data"] )

        if req.status != "OK"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        say "done", :green
      end
    end
  end
end

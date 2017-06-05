module ActiveRecord
  module Snapshot
    class MySQL
      def self.dump(*args)
        new.dump(*args)
      end

      def dump(tables:, output:)
        dump_command("--no-data #{database} > #{output}") &&
          dump_command("--quick #{database} #{tables} >> #{output}")
      end

      def self.import(*args)
        new.import(*args)
      end

      def import(input:)
        system(<<~SH)
          nice mysql \\
            --user #{user} \\
            --password #{password} \\
            --host #{host} \\
            #{database}
            < #{input}
        SH
      end

      private

      delegate :user, :password, :host, :database, to: :db_config

      def db_config
        ActiveRecord::Snapshot.config.db
      end

      def dump_command(args = "")
        system(<<~SH)
          nice mysqldump \\
            --user #{user} \\
            --password #{password} \\
            --host #{host} \\
            #{args}
        SH
      end
    end
  end
end
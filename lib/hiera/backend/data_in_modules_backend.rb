class Hiera
  module Backend
    class Data_in_modules_backend
      def initialize(cache=nil)
        require 'yaml'
        Hiera.debug("Hiera Data in modules backend starting")

        @cache = cache || Filecache.new
      end

      def load_data(path)
        return {} unless File.exist?(path)

        Hiera.debug("Looking for data in source %s" % path)

        if @cache
          @cache.read(path, Hash, {}) do |data|
            YAML.load(data)
          end
        else
          data = YAML.load_file(path)
          unless data.is_a?(Hash)
            data = {}
          end

          data
        end
      end

      def lookup(key, scope, order_override, resolution_type)
        answer = nil

        Hiera.debug("Looking up #{key} in Data in modules backend")

        unless scope["module_name"]
          Hiera.debug("Skipping Module Data backend as '%s' does not look like a module" % scope)
          return answer
        end

        Backend.datasources(scope, order_override) do |source|
          Hiera.debug("Looking for data source #{source} in module #{scope["module_name"]}")
          # yamlfile = Backend.datafile(:yaml, scope, source, "yaml") || next

          mod = Puppet::Module.find(scope["module_name"], scope["environment"])
          path = mod.path
          Hiera.debug("Module directory is #{path}")

          yamlfile = File.join(path, "data", "%s.yaml" % Backend.parse_string(source, scope))
          Hiera.debug("YAML file path is #{yamlfile}")

          next unless File.exist?(yamlfile)

          data = @cache.read(yamlfile, Hash, {}) do |data|
            YAML.load(data)
          end

          next if data.empty?
          next unless data.include?(key)

          # Extra logging that we found the key. This can be outputted
          # multiple times if the resolution type is array or hash but that
          # should be expected as the logging will then tell the user ALL the
          # places where the key is found.
          Hiera.debug("Found #{key} in #{source}")

          # for array resolution we just append to the array whatever
          # we find, we then goes onto the next file and keep adding to
          # the array
          #
          # for priority searches we break after the first found data item
          new_answer = Backend.parse_answer(data[key], scope)
          case resolution_type
          when :array
            raise Exception, "Hiera type mismatch: expected Array and got #{new_answer.class}" unless new_answer.kind_of? Array or new_answer.kind_of? String
            answer ||= []
            answer << new_answer
          when :hash
            raise Exception, "Hiera type mismatch: expected Hash and got #{new_answer.class}" unless new_answer.kind_of? Hash
            answer ||= {}
            answer = Backend.merge_answer(new_answer,answer)
          else
            answer = new_answer
            break
          end
        end

        return answer
      end
    end
  end
end

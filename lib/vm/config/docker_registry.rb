require 'teracy-dev/config/configurator'
require 'teracy-dev/plugin'

module VagrantVM
  module Config
    class DockerRegistry < TeracyDev::Config::Configurator
      def configure_common(settings, config)
        @docker_config = settings['vagrant-vm']['docker']

        @extension_lookup_path = TeracyDev::Util.extension_lookup_path(settings, 'vagrant-vm')

        login_docker(config) if @docker_config['enabled']
      end

      private

      def login_docker(config)
        @docker_config['entries'].each do |entry|
            registry_host = entry['host']

            if !registry_host.nil?
                config.vm.provision "shell",
                  run: "always",
                  env: {
                    'HOST' => registry_host.to_s, 
                    'USERNAME' => entry['username'].to_s,
                    'PASSWORD' => entry['password'].to_s,
                    'FORCE_LOGIN' => entry['force'].to_s,
                  },
                  path: "#{@extension_lookup_path}/vagrant-vm/shell/login_docker.sh",
                  name: "Login for #{registry_host}"
            end
        end if @docker_config['entries']
      end
    end
  end
end

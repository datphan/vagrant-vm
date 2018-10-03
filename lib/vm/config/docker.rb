require 'teracy-dev/config/configurator'
require 'teracy-dev/plugin'

module VagrantVM
  module Config
    class Docker < TeracyDev::Config::Configurator
      def configure_common(settings, config)
        @docker_config = settings['vagrant-vm']['docker']

        @extension_lookup_path = TeracyDev::Util.extension_lookup_path(settings, 'vagrant-vm')

        install_docker(config) if @docker_config['enabled']
      end

      private

      def install_docker(config)
        config.vm.provision "shell",
          run: "always",
          path: "#{@extension_lookup_path}/vagrant-vm/shell/install_docker.sh",
          name: "Install Docker"
      end
    end
  end
end

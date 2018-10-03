require 'teracy-dev/config/configurator'
require 'teracy-dev/plugin'

module TeracyDevEssential
  module Config
    class HostManager < TeracyDev::Config::Configurator
      PLUGIN_NAME = "vagrant-hostmanager"

      def configure_common(settings, config)
        configure_ip_display(config, settings)
      end

      private

      def install_docker(config, settings)
        extension_lookup_path = TeracyDev::Util.extension_lookup_path(settings, 'iorad-vm')

        config.vm.provision "shell",
          run: "always",
          args: [@host_ip_command],
          path: "#{extension_lookup_path}/teracy-dev-essential/provisioners/shell/ip_display.sh",
          name: "Display IP"
      end

      def configure_ip_display(config, settings)
        extension_lookup_path = TeracyDev::Util.extension_lookup_path(settings, 'teracy-dev-essential')

        config.vm.provision "shell",
          run: "always",
          args: [@host_ip_command],
          path: "#{extension_lookup_path}/teracy-dev-essential/provisioners/shell/ip_display.sh",
          name: "Display IP"
      end
    end
  end
end

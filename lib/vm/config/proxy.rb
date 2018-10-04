
require 'teracy-dev/config/configurator'
require 'teracy-dev/plugin'
require 'teracy-dev/util'

module VagrantVM
  module Config
    class Proxy < TeracyDev::Config::Configurator
      def configure_common(settings, config)
        @proxy_config = settings['vagrant-vm']['proxy']

        @extension_lookup_path = TeracyDev::Util.extension_lookup_path(settings, 'vagrant-vm')

        setup_proxy(config) if @proxy_config['enabled']
      end

      private

      def setup_proxy(config)
        volumes = (TeracyDev::Util.exist? @proxy_config['volumes']) ? \
          "-v #{@proxy_config['volumes'].join(' -v ')}" : ''
          
        port = (TeracyDev::Util.exist? @proxy_config['port']) ? \
          "-p #{@proxy_config['port'].join(' -p ')}" : ''

        config.vm.provision "shell",
          run: "always",
          env: {
            'NAME' => @proxy_config['name'], 
            'IMAGE' => @proxy_config['image'],
            'RESTART_POLICY' => @proxy_config['restart_policy'],
            'VOLUMES' => volumes,
            'PORT' => port,
          },
          path: "#{@extension_lookup_path}/vagrant-vm/shell/setup_proxy.sh",
          name: "Setup Proxy"
      end
    end
  end
end


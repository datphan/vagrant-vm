require 'teracy-dev/config/configurator'
require 'teracy-dev/plugin'

module VagrantVM
  module Config
    class Enviroment < TeracyDev::Config::Configurator
      def configure_common(settings, config)
        @enviroment_config = settings['vagrant-vm']['enviroment']

        set_enviroment(config) if @enviroment_config['enabled']
      end

      private

      def set_enviroment(config)
        cmd_list = []

        @enviroment_config['items'].each do |enviroment|
          prefix = (!enviroment['prefix'].to_s.empty?) ? "#{enviroment['prefix']}_" : ''
          subfix = (!enviroment['subfix'].to_s.empty?) ? "_#{enviroment['subfix']}" : ''
          items = enviroment['items']

          items.each do |key, value|
            env_key = "#{prefix}#{key}#{subfix}".upcase
            # cmd_list << <<-SCRIPT
            # if [ -z "$#{env_key}\" ] || [ "$#{env_key}" != "#{value}\" ]; then
            #   echo "export #{env_key}='#{value}'" > /etc/profile.d/vagrant-vm-env.sh;
            # else
            #   echo $#{env_key};
            # fi
            # SCRIPT

            cmd_list << <<-SCRIPT
              echo "export #{env_key}='#{value}'" >> /etc/profile.d/vagrant-vm-env.sh
            SCRIPT
          end
        end if @enviroment_config['items']

        # remove all env vars then re-export
        script = <<-SCRIPT
          > /etc/profile.d/vagrant-vm-env.sh
          #{cmd_list.join("")}
        SCRIPT

        @logger.debug("$script: #{$script}")

        config.vm.provision "shell",
          run: "always",
          name: "Set Enviroment",
          inline: script
      end
    end
  end
end

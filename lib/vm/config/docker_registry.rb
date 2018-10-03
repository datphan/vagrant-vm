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
        @docker_config['entries'].each do |entry, index|
            registry_host = entry['host']

            username = entry['username']

            password = entry['password']

            force_login = entry['force']

            if !registry_host.nil?
                config.vm.provision "shell",
                  run: "always",
                  args: [registry_host.to_s, username.to_s, password.to_s, force_login.to_s],
                  path: "#{@extension_lookup_path}/vagrant-vm/shell/login_docker.sh",
                  name: "Login for #{registry_host}"
            end
        end if @docker_config['entries']
      end
    end
  end
end



# execute 'rm ~/.docker/config.json' do
#         command 'rm /home/vagrant/.docker/config.json || true'
#         only_if {
#             docker_registry_conf['force'] == true and
#             File.exist?('/home/vagrant/.docker/config.json')
#         }
#     end

#     docker_registry_conf['entries'].each.with_index do |entry, index|
#         # private registry login

#         username = entry['username'] ? entry['username'] : ''

#         password = entry['password'] ? entry['password'] : ''

#         if not username.empty? and not password.empty?
#             opt = [
#                 "-u #{username}",
#                 "-p #{password}"
#             ].join(' ');

#             execute 'docker login' do
#                 command "docker login #{entry['host']} #{opt}"
#                 # because we need root to execute docker-compose, not 'vagrant'
#                 only_if {
#                     docker_registry_conf['force'] == true or
#                     not File.exist?('/root/.docker/config.json')
#                 }
#             end
#         end
#     end

#     execute 'copy /root/.docker/config.json to ~/.docker/config.json' do
#         command 'cp /root/.docker/config.json /home/vagrant/.docker/config.json'
#         only_if {
#             File.exist?('/root/.docker/config.json') and (
#                 docker_registry_conf['force'] == true or
#                 not File.exist?('/home/vagrant/.docker/config.json')
#             )
#         }
#     end
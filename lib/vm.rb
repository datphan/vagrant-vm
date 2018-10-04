require 'teracy-dev'

require_relative 'vm/config/docker'
require_relative 'vm/config/docker_registry'
require_relative 'vm/config/enviroment'
require_relative 'vm/config/template'

module VagrantVM

  def self.init
    TeracyDev.register_configurator(Config::Docker.new)
    TeracyDev.register_configurator(Config::DockerRegistry.new)
    TeracyDev.register_configurator(Config::Enviroment.new)
    TeracyDev.register_configurator(Config::Template.new)
  end

end

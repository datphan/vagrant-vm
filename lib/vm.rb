require 'teracy-dev'

require_relative 'vm/config/docker'
require_relative 'vm/config/docker_registry'

module VagrantVM

  def self.init
    TeracyDev.register_configurator(Config::Docker.new)
    TeracyDev.register_configurator(Config::DockerRegistry.new)
  end

end

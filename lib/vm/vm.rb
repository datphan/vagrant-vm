require 'teracy-dev'

require_relative 'vm/config/docker'

module IoradVM

  def self.init
    TeracyDev.register_configurator(Config::Docker.new)
  end

end

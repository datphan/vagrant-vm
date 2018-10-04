require 'teracy-dev/config/configurator'
require 'teracy-dev/plugin'
require 'teracy-dev/util'

module VagrantVM
  module Config
    class Template < TeracyDev::Config::Configurator
      def configure_common(settings, config)
        @template_config = settings['vagrant-vm']['template']

        @template_lookup_path = (TeracyDev::Util.exist? @template_config['lookup']) ? @template_config['lookup'] : TeracyDev::Util.extension_lookup_path(settings, 'vagrant-vm')

        write_template(config) if @template_config['enabled']
      end

      private

      def write_template(config)
        template_script = []

        @template_config['items'].each do |template|
          file_path = "#{@template_lookup_path}/#{template['filename']}"

          file_name = File.basename(file_path, File.extname(file_path))

          @logger.debug("file_path: #{file_path}, file_name: #{file_name}")

          write_target = (TeracyDev::Util.exist? template['target']) ? template['target'] : '/home/vagrant'

          result = []

          formatedValues = {}

          template['values'].each do |key, value|
            formatedValues[key.to_sym] = value
          end

          @logger.debug("formatedValues: #{formatedValues}")

          File.open(file_path, "r") do |f|
            f.each_line do |line|
              result << line.to_s % formatedValues
            end
          end if File.exist? file_path

          template_script << <<-SCRIPT
            echo "editing #{write_target}/#{file_name}"
            cd #{write_target}
            touch #{file_name}
            echo '#{result.join("\n")}' > #{file_name}
          SCRIPT
        end if @template_config['items']

        script = <<-SCRIPT
          pwd
          #{template_script.join("")}
        SCRIPT

        config.vm.provision "shell",
          run: "always",
          name: "Generate Template",
          inline: script
      end
    end
  end
end

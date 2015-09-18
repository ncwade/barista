require 'fileutils'
require_relative './utilities.rb'
require_relative 'pot.rb'

def barista_install(options)
  package_path = get_package_path(options[:package])
  if package_path != nil then
    require package_path.strip
    file_name = File.basename(package_path.strip, '.rb')

    pot = Pot.new('Brewfile')

    FileUtils.mkdir_p '.brew/' + file_name + '/'

    # Configure destination directory.
    path = `pwd`
    dest = path.strip + '/.brew/' + file_name

    FileUtils.mkdir_p '.brew/sandbox/'
    Dir.chdir('.brew/sandbox/') do
      newObject = eval(file_name.capitalize).new(pot.toolchain, pot.sysroot, pot.prefix, dest)
      newObject.install
    end
  else
    puts "Could not find package requested."
    return false
  end
  true
end

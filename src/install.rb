require_relative './utilities.rb'
require_relative 'pot.rb'

def barista_install(options)
  package_path = get_package_path(options[:package])
  if package_path != nil then
    require package_path.strip
    file_name = File.basename(package_path.strip, '.rb')

    pot = Pot.new('Brewfile', '', '')

    Dir.rmdir('.brew/'+file_name+'/') unless !File.exists?('.brew/'+file_name+'/')
    Dir.mkdir('.brew/'+file_name+'/') unless File.exists?('.brew/'+file_name+'/')

    Dir.mkdir('.brew/sandbox/')
    Dir.chdir('.brew/sandbox/') do
      newObject = eval(file_name.capitalize).new
      newObject.install(pot.get_toolchain, `pwd`+'/.brew/'+file_name, pot.get_sysroot)
    end
    # Dir.rmdir('.brew/sandbox/')
  else
    puts "Could not find package requested."
    return false
  end
  return true
end
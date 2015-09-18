# Defines the "Brewfile" configuration.

require 'json'

class Pot
  @@filePath = "Brewfile"
  @@parameters = Hash.new

  # Set the member variables.
  def initialize(target)
    if (target == @@filePath)
      @configFile = File.read(target)
      @@parameters  = JSON.parse(@configFile)

      # Parse file information.
      @fileContent = File.read(@@parameters['image'])
      @baseInfo  = JSON.parse(@fileContent)
    else
      if File.file?(target) then
        # Get the complete path
        path = `pwd`

        # Parse file information.
        @fileContent = File.read(target)
        @baseInfo  = JSON.parse(@fileContent)

        @@parameters['toolchain'] = path.strip + '/.brew/toolchain/bin/'
        @@parameters['prefix'] = @baseInfo['prefix']
        @@parameters['sysroot'] = path.strip + '/.brew/toolchain/' + @@parameters['prefix'] + '/sysroot/'
        @@parameters['image'] = path.strip + '/' + target
      end
    end

    # Create directory structure.
    Dir.mkdir('.brew') unless File.exists?('.brew')
    Dir.mkdir('.brew/toolchain/') unless File.exists?('.brew/toolchain/')

    # Pull the base FS image.
    if !File.exists?('.brew/base_image')
       system 'wget '+ @baseInfo['fs_base'] + ' -O .brew/base_image'
    end

    if !File.exists?('.brew/toolchain_archive')
      # Pull the toolchain
      system 'wget '+ @baseInfo['toolchain'] + ' -O .brew/toolchain_archive'
      # Extract toolchain
      system 'tar -xf .brew/toolchain_archive -C .brew/toolchain/'
    end
  end

  def toolchain
    @@parameters['toolchain']
  end

  def sysroot
    @@parameters['sysroot']
  end

  def prefix
    @@parameters['prefix']
  end

  # Get all the projects currently in the Brew.
  def projects
    @@parameters['projects'] .each do |project|
      puts project['name']
    end
    @@parameters['projects']
  end

  # Add a project to the Brew.
  def add_project(new_project)
    @@parameters['projects'].insert(-1, new_project)
  end

  # Save the Brew back to JSON format.
  def save()
    File.open(@@filePath,"w") do |fileHandle|
      fileHandle.write(JSON.pretty_generate(@@parameters))
    end
  end

end

# Defines the "Brewfile" configuration.

require 'json'
require_relative 'images.rb'
require_relative 'toolchain.rb'

class Pot
  @@filePath = "Brewfile"
  @@parameters =  Hash.new

  # Set the member variables.
  def initialize(filePath,toolchain,baseimage)
    # Instance variables
    if File.file?(filePath) then
      @configFile = File.read(filePath)
      @@parameters  = JSON.parse(@configFile)
    else
      @@parameters['baseimage'] = baseimage
      @@parameters['toolchain'] = toolchain
      Dir.mkdir('.brew') unless File.exists?('.brew')
      Dir.mkdir('.brew/image') unless File.exists?('.brew/image')
      Dir.mkdir('.brew/'+@@parameters['toolchain']+'/') unless File.exists?('.brew/'+@@parameters['toolchain']+'/')
    end
  end

  # Grab the base image.
  def baseimage
    image = Image.new(@@parameters['baseimage'])
    return false if !image.retrieve_image
    return false if !image.extract_image
    return true
  end

  # Get the toolchain
  def toolchain
    toolchain = Toolchain.new(@@parameters['toolchain'])
    return false if !toolchain.retrieve_toolchain
    return false if !toolchain.extract_toolchain
    return true
  end

  def get_toolchain
    return @@parameters['toolchain']
  end

  def get_sysroot
    current_path = `pwd`
    return current_path.strip+"/"+".brew/image"
  end

  # Get all the projects currently in the Brew.
  def projects
    @@parameters['projects'] .each do |project|
      puts project['name']
    end
    return @@parameters['projects']
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

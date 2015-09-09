# Defines the "Brewfile" configuration.

require 'json'
require_relative 'images.rb'

class Pot
  @@filePath = "Brewfile"
  @@parameters =  Hash.new

  # Set the member variables.
  def initialize(filePath,toolchain,prefix,baseimage)
    # Instance variables
    if File.file?(filePath) then
      @configFile = File.read(filePath)
      @@parameters  = JSON.parse(@configFile)
    else
      @@parameters['baseimage'] = baseimage
      @@parameters['toolchain'] = toolchain
      @@parameters['toolchain-prefix'] = prefix
      Dir.mkdir('.brew') unless File.exists?('.brew')
      Dir.mkdir('.brew/image') unless File.exists?('.brew/image')
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
    return @@parameters['toolchain']
  end

  # Get the toolchain prefix.
  def prefix
    return @@parameters['toolchain-prefix']
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

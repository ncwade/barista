# Defines the "Brewfile" configuration.

require 'json'

class Pot
    @@filePath = "Brewfile"
    @@parameters =  Hash.new

    # Set the member variables.
    def initialize(filePath)  
        # Instance variables
        if File.file?(filePath) then
            @configFile = File.read(filePath)
            @@parameters  = JSON.parse(@configFile)
        else
            @@parameters['baseimage'] = "linux-x86"  
            @@parameters['toolchain'] = "gcc"  
            @@parameters['toolchain-prefix'] = ""
            Dir.mkdir('.brew') unless File.exists?('.brew')
        end
    end

    # Grab the Linux base image.
    def baseimage
        return @@parameters['baseimage'] 
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
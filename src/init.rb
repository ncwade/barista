# Includes
require_relative 'pot.rb'

# Create the base directory.
def barista_init(options)
  pot = Pot.new('', options[:toolchain], options[:baseimage])
  pot.baseimage
  pot.toolchain
  pot.save
end
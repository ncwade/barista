# Includes
require_relative 'pot.rb'

# Create the base directory.
def barista_init(options)
  pot = Pot.new('', options[:toolchain], options[:prefix], options[:baseimage])
  pot.baseimage
  pot.save
end
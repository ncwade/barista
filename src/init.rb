
require_relative 'pot.rb'

# Create the base directory.
def barista_init(options)
  pot = Pot.new("cfg/#{options[:target]}.cfg")
  pot.save
end

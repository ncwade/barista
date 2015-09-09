# Defines the image we are utilizing as the base of our filesystem.

require 'open-uri'
require 'json'
require 'digest/md5'
require 'rubygems/package'
require 'zlib'

class Image

  TAR_LONGLINK = '././@LongLink'

  # Set the member variables.
  def initialize(image)
    @imageFile = File.read('images/'+image+'.json')
    @@parameters  = JSON.parse(@imageFile)
    @@image = image
  end

  def retrieve_image
    open('.brew/baseimage', 'wb') do |file|
      file << open(@@parameters['url']).read
    end
    md5 = Digest::MD5.file('.brew/baseimage').hexdigest
    if md5 != @@parameters['md5'] then
      puts "MD5sum does not match"
      return false
    end

    return true
  end

  def extract_image
    imageFile = File.read('images/'+@@image+'.json')
    @@parameters  = JSON.parse(imageFile)
    case @@parameters['format']
      when "gzip"
        system 'fakeroot tar -zxvf .brew/baseimage -C .brew/image/ > /dev/null 2>&1'
      when "jffs2"
        puts 'JFFS2 not supported yet.'
      when "cramfs"
        puts 'CRAMFS not supported yet.'
      else
        puts "No file format defined for this image."
        return false
    end
    return true
  end

end
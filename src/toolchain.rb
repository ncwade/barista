# Defines the toolchain to use for the build.

class Toolchain
  # Set the member variables.
  def initialize(toolchain)
    @toolchainFile = File.read('toolchains/'+toolchain+'.json')
    @@parameters  = JSON.parse(@toolchainFile)
    @@toolchain = toolchain
  end


  def retrieve_toolchain
    system 'wget '+ @@parameters['url'] + ' -O .brew/toolchain_archive > /dev/null 2>&1'
    md5 = Digest::MD5.file('.brew/toolchain_archive').hexdigest
    if md5 != @@parameters['md5'] then
      puts "MD5sum does not match"
      return false
    end
    return true
  end

  def extract_toolchain
    case @@parameters['format']
      when "gzip"
        system 'tar -zxvf .brew/toolchain_archive -C .brew/'+@@toolchain+'/ > /dev/null 2>&1'
      else
        puts "No file format defined for this image."
        return false
    end
    return true
  end

end
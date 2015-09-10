
# Recipe

require_relative "extensions/module.rb"

# class Wget < Recipe
#   homepage "https://www.gnu.org/software/wget/"
#   url "https://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz"
#   sha256 "52126be8cf1bddd7536886e74c053ad7d0ed2aa89b4b630f76785bac21695fcd"
#
#   def install
#     system "./configure", "--prefix=#{prefix}"
#     system "make", "install"
#   end
# end

module Commander
  def system(cmd, *args)
    # pid = fork { exec(cmd, *args) }
    pid = spawn(cmd, *args)
    Process.wait(pid)
    $stdout.flush
    puts $?.success?
  end
end

class Recipe
  include Commander

  def initialize
  end

  def install(toolchain, prefix, sysroot)
  end

  class << self
    attr_rw :desc
    attr_rw :homepage

    def url(val, specs = {})
    end

    def depends_on(dep)
    end

    def option(name, description = "")
    end
  end
end

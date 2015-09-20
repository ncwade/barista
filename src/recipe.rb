
# Recipe

require 'ostruct'
require 'uri'
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

# Execute system commands (in OS shell)
module Commander
  def system(cmd, *args)
    # pid = fork { exec(cmd, *args) }
    pid = spawn(cmd, *args)
    Process.wait(pid)
    $stdout.flush
    # puts $?.success?
  end
end

# Collection of convenient, configured, build-system commands
module Conductor
  include Commander

  def configure(args)
    system "CC=#{prefix}-clang PATH=#{toolchain}:$PATH ./configure --host=#{prefix} --prefix=#{destination} #{args}"
  end

  def make(target = nil)
    system "PATH=#{toolchain}:$PATH make #{target}"
  end

  def cmake(options, path)
    # CMAKE_SKIP_RPATH: tell cmake that we don't need a 'relink' step before install
    # => see cmGeneratorTarget::NeedRelinkBeforeInstall()

    system "BREW=$HOME/Development/barista/.brew/   \
            CC=/usr/local/opt/llvm/bin/clang        \
            CXX=/usr/local/opt/llvm/bin/clang++     \
            cmake #{options}                            \
                  -DCMAKE_SYSROOT=#{sysroot}            \
                  -DCMAKE_INSTALL_PREFIX=#{sysroot}/usr \
                  -DCMAKE_TOOLCHAIN_FILE=$HOME/Development/barista/etc/clang_cross.toolchain.cmake \
                  -DCMAKE_SKIP_RPATH=ON \
                  #{path}"
  end

  def ninja(target = nil)
    system "ninja #{target}"
  end
end

module Cookbook
  def self.recipe(name, &block)
    recipe = Recipe.new
    recipe.instance_eval(&block)

    @recipes ||= {}
    @recipes[name] = recipe
  end

  def self.recipes
    @recipes ||= {}
    @recipes
  end
end

class Recipe
  include Conductor

  URL = Struct.new("URL", :path, :method)

  attr_reader :url

  attr_reader :toolchain
  attr_reader :sysroot
  attr_reader :prefix
  attr_reader :destination

  def initialize
    @attrs = {}
  end

  def method_missing(name, *args, &block)
    @attrs[name.to_sym] = args[0]
  end

  def url(path, method = :http)
    @url = URL.new(path, method)
  end

  def download
    case @url.method
    when :http
      uri = URI.parse(@url.path)
      filename = File.basename(uri.path)
      if !File.exists? filename
        system "wget", @url.path
      end
      system "tar", "-xf", filename
      filename.sub(/\.tar\..*$/, "")
    when :git
      uri = URI.parse(@url.path)
      filename = File.basename(uri.path).sub(/\.git$/, "")
      if !File.exists? filename
        system "git", "clone", @url.path
      end
      filename
    end
  end

  def setup(toolchain, sysroot, prefix, destination)
    @toolchain = toolchain
    @sysroot = sysroot
    @prefix = prefix
    @destination = destination

    download()
  end

  def install
  end
end

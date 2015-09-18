
# Recipe

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

module Commander
  def system(cmd, *args)
    # pid = fork { exec(cmd, *args) }
    pid = spawn(cmd, *args)
    Process.wait(pid)
    $stdout.flush
    # puts $?.success?
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
  include Commander

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

  def configure(args)
    system "CC=#{prefix}-clang PATH=#{toolchain}:$PATH ./configure --host=#{prefix} --prefix=#{destination} #{args}"
  end

  def make(target = nil)
    system "PATH=#{toolchain}:$PATH make #{target}"
  end

  def download
    url = @attrs[:url]
    uri = URI.parse(url)
    filename = File.basename(uri.path)
    if !File.exists? filename
      system "wget", url
    end
    filename
  end

  def setup(toolchain, sysroot, prefix, destination)
    @toolchain = toolchain
    @sysroot = sysroot
    @prefix = prefix
    @destination = destination

    filename = download()
    system "tar", "-xf", filename
    filename.sub(/\.tar\..*/, "")
  end

  def install
  end
end

require_relative '../src/recipe.rb'

class Tftp < Recipe
  def install(toolchain, sysroot, prefix, destination)
    system "wget", "https://www.kernel.org/pub/software/network/tftp/tftp-hpa-0.40.tar.gz"
    system "tar", "xf", "tftp-hpa-0.40.tar.gz"
    Dir.chdir('tftp-hpa-0.40') do
      cmd = "bash -c \"export PATH=$PATH:#{toolchain} && ./configure --host=#{prefix} --prefix=#{destination} && make && make install\""
      system cmd
    end
  end
end

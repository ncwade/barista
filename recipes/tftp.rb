require_relative '../src/recipe.rb'

class Tftp < Recipe
  def install
    system "wget", "https://www.kernel.org/pub/software/network/tftp/tftp-hpa-0.40.tar.gz"
    system "tar", "xf", "tftp-hpa-0.40.tar.gz"
    Dir.chdir('tftp-hpa-0.40') do
      configure "--without-readline"
      make :clean
      make
    end
  end
end

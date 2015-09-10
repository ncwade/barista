require_relative '../src/recipe.rb'

class Test < Recipe
  def install(toolchain, prefix, sysroot)
    system "wget", "https://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz"
    system "tar", "xf", "wget-1.15.tar.gz"
    Dir.chdir('wget-1.15') do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end

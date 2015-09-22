
Cookbook.recipe("tftp") do
  url "https://www.kernel.org/pub/software/network/tftp/tftp-hpa-0.40.tar.gz"

  def install
    configure "--without-readline"
    make
    make :install
  end
end

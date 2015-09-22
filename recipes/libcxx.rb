
Cookbook.recipe("libcxx") do
  url "http://llvm.org/git/libcxx.git", :git

  def install
    # FileUtils.rm_rf '.build'
    FileUtils.mkdir_p '.build'
    Dir.chdir('.build') do
      cmake "-G Ninja -DLIBCXX_CXX_ABI=libcxxrt -DLIBCXX_CXX_ABI_INCLUDE_PATHS=$HOME/Development/barista/.brew/sandbox/libcxxrt/src -DCMAKE_BUILD_TYPE=Release", ".."
      ninja
      ninja :install
    end
  end
end

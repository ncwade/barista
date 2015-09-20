
Cookbook.recipe("libcxxrt") do
  url "https://github.com/pathscale/libcxxrt.git", :git

  def install
    FileUtils.rm_rf '.build'
    FileUtils.mkdir_p '.build'
    Dir.chdir('.build') do
      cmake "-G Ninja", ".."
      ninja

      # install in sysroot
      FileUtils.mkdir_p "#{@sysroot}/usr/lib"
      FileUtils.cp "lib/libcxxrt.so", "#{@sysroot}/usr/lib"
    end
  end
end

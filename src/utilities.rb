require 'open3'

def get_package_path(package)
  stdin, stdout, stderr, wait_thr = Open3.popen3('find `pwd` -name ' + package.downcase+'.rb')
  output = stdout.gets(nil)
  stdout.close
  stderr.gets(nil)
  stderr.close
  exit_code = wait_thr.value
  output
end

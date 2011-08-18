LOGIN_USER = "root"
WYRD_SERVER = "186.202.61.143"

task :clean do |t|
  print "[wyrd] Cleaning local files... "
  %x(rm -rf ../wyrd_*)
  puts "done!"

  print "[wyrd] Cleaning server files... "
  %x(ssh #{LOGIN_USER}@#{WYRD_SERVER} 'rm -rf wyrd*')
  puts "done!"
end

task :deploy => [:clean] do |t|
  puts "[wyrd] Generating the Debian package"
  %x(dpkg-buildpackage)
  puts "[wyrd] Debian package done!"

  puts "[wyrd] Copying the Debian package to wyrd server"
  %x(scp ../wyrd*.deb #{LOGIN_USER}@#{WYRD_SERVER}:~)

  puts "[wyrd] Installing the new version"
  %x(ssh #{LOGIN_USER}@#{WYRD_SERVER} 'dpkg -i wyrd*')

  puts "[wyrd] Installation done! \\,,/"
end

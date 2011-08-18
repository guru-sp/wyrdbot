LOGIN_USER = "root"
WYRD_SERVER = "186.202.61.143"

task :clean do |t|
  %x(rm -rf ../wyrd_*)
  %x(ssh #{LOGIN_USER}@#{WYRD_SERVER} 'rm -rf wyrd*')
end

task :deploy => [:clean] do |t|
  %x(dpkg-buildpackage)
  %x(scp ../wyrd*.deb #{LOGIN_USER}@#{WYRD_SERVER}:~)
  %x(ssh #{LOGIN_USER}@#{WYRD_SERVER} 'dpkg -i wyrd*')
end

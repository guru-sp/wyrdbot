require 'bundler'
Bundler.setup

require 'rspec/core/rake_task'

LOGIN_USER = "root"
WYRD_SERVER = "186.202.61.143"

task :default => [:spec]

task RSpec::Core::RakeTask.new

desc "Clean local configuration files"
task :clean do |t|
  print "[wyrd] Cleaning local files... "
  %x(rm -rf ../wyrd_*)
  puts "done!"

  print "[wyrd] Cleaning server files... "
  %x(ssh #{LOGIN_USER}@#{WYRD_SERVER} 'rm -rf wyrd*')
  puts "done!"
end

desc "Generate debian package and deploy it"
task :deploy => [:clean] do |t|
  puts "[wyrd] Generating the Debian package"
  %x(dpkg-buildpackage)
  puts "[wyrd] Debian package done!"

  puts "[wyrd] Copying the Debian package to wyrd server"
  %x(scp ../wyrd*.deb #{LOGIN_USER}@#{WYRD_SERVER}:~)

  puts "[wyrd] Installing the new version"
  %x(ssh #{LOGIN_USER}@#{WYRD_SERVER} 'dpkg -i wyrd*')

  puts "[wyrd] Installation done! \\,,/"

  # Removing bundler configurations in development
  %x(rm -rf .bundle)
end

desc "Backup quotes"
task :backup do |t|
  puts "[wyrd] Backup quotes"
  %x(ssh #{LOGIN_USER}@#{WYRD_SERVER} 'tar czvf ~/wyrd_quotes.tar.gz /opt/wyrd/talk_files/*.yml')
end

desc "Download backed up quotes"
task :quotes => [:backup] do |t|
  puts "[wyrd] Downloading quotes backups"
  %x(scp #{LOGIN_USER}@#{WYRD_SERVER}:~/wyrd_quotes.tar.gz talk_files/)
end

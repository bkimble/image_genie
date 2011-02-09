require 'rubygems'  
require 'rake'
require 'echoe'  
require 'rake/testtask'

Echoe.new('image_genie', '0.3.0') do |p|  
  p.description     = "ImageGenie - Simple Wrapper for command line ImageMagick"  
  p.url             = "https://github.com/bkimble"
  p.author          = "Billy Kimble"  
  p.email           = "basslines@gmail.com"  
  p.ignore_pattern  = ["tmp/*", "script/*"]  
  p.development_dependencies = ["open4"]  
end  

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end
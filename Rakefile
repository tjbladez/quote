require 'rake'
require 'rake/testtask'

desc "Run tests by default"
task :default => [:test]

desc "Test that thing"
task :test
Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
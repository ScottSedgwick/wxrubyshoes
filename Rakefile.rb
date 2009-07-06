require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
	s.name = "wxrubyshoes"
	s.version = "0.0.1"
	s.author = "Scott Sedgwick"
	s.email = "scott.sedgwick@gmail.com"
	s.platform = Gem::Platform::RUBY
	s.summary = "A shoes-like interface to wxruby2."
	s.require_path = "lib"
	s.files =  FileList['lib/*.rb'].to_a
	s.has_rdoc = false
	s.add_dependency("wxruby", ">=2.0.0")
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
	pkg.need_tar = true 
end 

desc 'Run the example app'
task :example do
	sh 'ruby -Ilib examples/example01.rb'
end
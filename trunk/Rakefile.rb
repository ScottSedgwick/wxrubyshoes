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

namespace :demo do
	namespace :old do
		# This gets most of the examples...
		FileList.new('samples/samples_wx/*').to_a.each do |path|
			if File.directory?(path) 
				basename = File.basename(path)
				if File.exists?("#{path}/#{basename}.rb")
					desc "Original #{basename} sample"
					task basename.to_sym do
						sh "ruby #{path}/#{basename}.rb"
					end
				end
			end
		end
		
		# Special cases...
		namespace :bigdemo do
			FileList.new('samples/samples_wx/bigdemo/*.rbw').to_a.each do |filename|
				basename = File.basename(filename)
				basename.gsub!(File.extname(basename), '')
				desc "Original BigDemo sample (#{basename}"
				task basename.to_sym do
					sh "ruby samples/samples_wx/bigdemo/run.rb #{filename}"
				end
			end
		end
		
		['drawing', 'etc', 'opengl', 'text', 'xrc'].each do |path|
			namespace path.to_sym do
				FileList.new("samples/samples_wx/#{path}/*.rb").to_a.each do |filename|
					basename = File.basename(filename)
					basename.gsub!(File.extname(basename), '')
					desc "Original Drawing sample (#{basename}"
					task basename.to_sym do
						sh "ruby #{filename}"
					end
				end
			end
		end
		
		task :sockets do
		end
	end
end

desc 'Run the example app'
task :example do
	sh 'ruby -Ilib examples/example01.rb'
end
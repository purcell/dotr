require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'

# Meta -------------------------------
PKG_VERSION = "0.3"
RUBYFORGE_PROJECT = "dotr"
RUBYFORGE_USER = "purcell"
PKG_NAME = "DotR"
PKG_SUMMARY = "Produce directed graph images using the 'dot' utility."


# Coding -------------------------------
desc 'Run Tests'
Rake::TestTask.new :test do |t|
  t.test_files = FileList['test/*.rb']
end


# Sharing -------------------------------
PKG_FILES = FileList["lib/*.rb", "test/*.rb"]

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = PKG_SUMMARY
  s.name = RUBYFORGE_PROJECT
  s.version = PKG_VERSION
  s.requirements << 'none'
  s.require_path = 'lib'
  s.files = PKG_FILES
  s.has_rdoc = true
  s.description = <<-EOF
  EOF
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = PKG_NAME + " -- " + PKG_SUMMARY
  rdoc.options << '--line-numbers' << '--inline-source' << '--accessor' << 'cattr_accessor=object'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/*.rb')
}

desc "Publish the API documentation"
task :publish => [:rdoc] do
  Rake::RubyForgePublisher.new(RUBYFORGE_PROJECT, RUBYFORGE_USER).upload
end

task :dist => [:test, :rdoc, :package]

task :default => [:test]


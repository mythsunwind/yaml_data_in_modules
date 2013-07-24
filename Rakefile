require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |gem|
    gem.name = "hiera_data_in_modules"
    gem.version = "0.0.1"
    gem.summary = "Data-in-modules backend for Hiera"
    gem.email = "svj@spreadshirt.net"
    gem.author = "Sven Jost"
    gem.homepage = "http://github.com/"
    gem.description = "Hiera backend for looking up data in puppet modules"
    gem.require_path = "lib"
    gem.files = FileList["lib/**/*"].to_a
    gem.add_dependency('json', '>=1.1.1')
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end

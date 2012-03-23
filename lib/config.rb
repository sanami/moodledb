require 'bundler'
Bundler.require

require 'ostruct'
require 'pp'
require 'pathname'
require 'logger'

ROOT_PATH = Pathname.new File.expand_path('../../', __FILE__)

def ROOT(file)
	ROOT_PATH + file
end

# Ensure existing folders
['log', 'tmp'].each do |path|
	FileUtils.mkpath ROOT(path)
end

# Required folders
['lib'].each do |folder|
	$: << ROOT(folder)
end
#pp $:

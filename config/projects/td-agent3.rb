require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "Treasure Agent: A data collector for Treasure Data"

if windows?
  install_dir "#{default_root}/opt/#{name}"
else
  install_dir "#{default_root}/#{name}"
end

build_version   "3.4.2"
build_iteration 0

# creates required build directories
dependency "preparation"

override :ruby, :version => '2.6.3'
override :zlib, :version => '1.2.11'
override :jemalloc, :version => '5.2.0'
override :rubygems, :version => '3.0.3'
override :postgresql, :version => '9.6.9'
override :fluentd, :version => '45c7b75ba77763eaf87136864d4942c4e0c5bfcd' # v1.5.1

# td-agent dependencies/components
dependency "td-agent"
dependency "td-agent-files"
dependency "td"
#dependency "td-agent-ui" # fluentd-ui doesn't work with ruby 2.4 because some gems depend on json 1.8
dependency "td-agent-cleanup"

# version manifest file
dependency "version-manifest"

case ohai["os"]
when "linux"
  case ohai["platform_family"]
  when "debian"
    runtime_dependency "lsb-base"
  when "rhel", "amazon"
    runtime_dependency "initscripts"
    runtime_dependency "cyrus-sasl-lib" # for rdkafka
    if ohai["platform_version"][0] == "5"
      runtime_dependency "redhat-lsb"
    else
      runtime_dependency "redhat-lsb-core"
    end
  end
end

exclude "\.git*"
exclude "bundler\/git"

compress :dmg do
end

package :msi do
  upgrade_code "76dcb0b2-81ad-4a07-bf3b-1db567594171"
end

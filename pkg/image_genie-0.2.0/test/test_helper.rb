require 'rubygems'
require 'tempfile'
require 'test/unit'
require 'active_support'
require 'active_support/inflector' # needed for string methods like underscore
require 'open4'
require 'mocha'
require 'image_genie'

require 'active_support/testing/declarative'
include ActiveSupport::Testing::Declarative # for syntactic sugar of "test 'foo' do .."

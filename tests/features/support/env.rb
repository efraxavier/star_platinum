require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require 'rspec'
require 'httparty'
require_relative 'helper.rb'

amb = ENV['ENV_RUN']

CONFIG = YAML.load_file(File.dirname(__FILE__) + "/ambientes/#{amb}.yml")
World(Helper)



Capybara.configure do |config|
    config.default_driver = :selenium_chrome
    config.app_host = CONFIG['url_default']
    config.default_max_wait_time = 10
end
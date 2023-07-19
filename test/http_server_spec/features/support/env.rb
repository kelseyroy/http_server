require "rspec/expectations"
require "yaml"

file_path = File.expand_path(File.join(File.dirname(__FILE__), "config.yml"))
yaml = YAML.load_file(file_path)
HOSTNAME = yaml["server"]["hostname"]
PORT = yaml["server"]["port"]
PROTOCOL = yaml["server"]["protocol"]

Spinach.hooks.after_run do |status|
    pn = File.expand_path('../../../../lib/http_server_fixture/data/test-data.json', __dir__)
    File.delete(pn) if File.exist?(pn)
    file_deleted = "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\ntest-data file deleted\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts file_deleted unless File.exist?(pn)
end

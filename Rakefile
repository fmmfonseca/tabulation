$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"

require 'rake'
require 'rake/clean'
require 'lib/tabulation'

# Load tasks
Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].each { |ext| load ext }

# Default task
task :default => ["test:unit"]
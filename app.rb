#
#
#
# todo: instead of default to success, default to failure if no success string.
#
#
#

require_relative 'lib/SeleniumRunner'
require_relative 'config/vars'
require 'sinatra'

set :server, 'thin'

get '/' do
  "Nothing to see here."
end

get '/:name' do

  # 
  # Get our parameters
  #
  key = params[:key]
  site = params[:name]

  if (key != VALIDATION_KEY)
    
    "FAILURE: Bad credentials."

  else

    if (File.directory?('./tests/'+site))

      test_files = Array.new

      # 
      # Find all files in the directory
      # 
      Dir.glob('./tests/'+site+'/*.rb') do |file|
        test_files << file
      end

      if (!test_files.empty?)

        tests = SeleniumRunner.new(test_files, site)
        tests.run
        "SUCCESS: Tests are now running for #{site}."

      else

        "FAILURE: No test files found in directory."

      end


    else

      "FAILURE: No such test group."
    
    end

  end

end

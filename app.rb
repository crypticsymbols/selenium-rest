require_relative 'lib/notifier'
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

      # 
      # Run in a thread so sinatra can return an HTTP response quickly.
      #
      Thread.new { 

        errors = ''

          test_files.each do |t|

            # 
            # Run the selenium test and give us a variable
            # containing its output.
            # 
            message = `ruby #{t}`

            if message.include? "Error:"
              errors << message
              errors << '<br/>'
            end

          end

          if (!errors.empty?)
            title = "Selenium Test failure report"
            Notifier.new(LOG_EMAIL_SENDER, LOG_EMAIL_RECIPIENT, title, errors)
          end

      }

      "SUCCESS: Tests are now running for #{site}."

    else

      "FAILURE: No such test group."
    
    end

  end

end

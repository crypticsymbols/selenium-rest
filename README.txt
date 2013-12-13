This app listens for http requests, and runs headless selenium tests when it gets them.  In addition to the normal ruby stuff, you will need to install 2 additional packages:

1) Firefox (apt-get install firefox) (this app is firefox specific - it's not doing cross-bowser everything, it's just a basic broken/not broken tester).

2) xvfb (apt-get install xvfb), so firefox can run headless.

Once you get the app up and running, the easiest way to generate selenium tests is the use the Selenium IDE for firefox.  Export your tests as Ruby / Test::Unit / WebDriver.  You will need to add some lines to handle the headlessness of it all - see the included sample test (tests/sample/sample.test).  Without these additions, your tests will fail early because firefox can't run without a fake screen (which makes sense).

The app will listen for a request to yourapp.com/sitename?key=your-key.  Set the validation key in config/vars.rb.  When this URL is hit, it will run all the tests in the 'sample' directory.

If any of the tests return a value containing "Error:", and you've set up your emailer - I'm using mandrill because I don't want failed tests in my spam box - you'll get an email.  The formatting isn't pretty but you can make out which tests failed just fine.

I like to add a wget to this app into my capistrano stages like this:

namespace :testing do
	task :selenium do
		run "curl #{test_server}/#{test_folder}?key=#{selenium_api_key}"
	end
end

after "drupal:restart_apache", "testing:selenium"

On staging only, of course...

Happy testing!
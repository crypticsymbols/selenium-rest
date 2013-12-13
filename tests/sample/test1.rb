require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"

########################
# ADDED
########################
require "headless"
########################
# END ADDED
########################

class Thisthishti < Test::Unit::TestCase

  ########################
  # ADDED
  ########################
  class << self
    def startup
      @headless = Headless.new
      @headless.start
    end
    def shutdown
      @driver = nil
      @headless.destroy
      @headless = nil
    end
  end
  ########################
  # END ADDED
  ########################

  def setup
  	@driver = Selenium::WebDriver.for :firefox
    @base_url = "http://example.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_thisthishti
    @driver.get(@base_url + "/user")
    @driver.find_element(:id, "edit-pass").clear
    @driver.find_element(:id, "edit-pass").send_keys "strongpassword"
    @driver.find_element(:id, "edit-name").clear
    @driver.find_element(:id, "edit-name").send_keys "myusername"
    @driver.find_element(:id, "edit-submit").click
    @driver.find_element(:link, "Content").click
    @driver.find_element(:link, "Add content").click
    @driver.find_element(:link, "Post").click
    @driver.find_element(:id, "edit-title").clear
    @driver.find_element(:id, "edit-title").send_keys "ohai"
    @driver.find_element(:id, "edit-field-tagline-und-0-value").clear
    @driver.find_element(:id, "edit-field-tagline-und-0-value").send_keys "no way buddy"
    @driver.find_element(:id, "edit-field-featured-image-location-und-body").click
    @driver.find_element(:id, "edit-field-external-link-und-0-title").clear
    @driver.find_element(:id, "edit-field-external-link-und-0-title").send_keys "foo"
    @driver.find_element(:id, "edit-field-external-link-und-0-url").clear
    @driver.find_element(:id, "edit-field-external-link-und-0-url").send_keys "google.com"
    @driver.find_element(:id, "edit-field-category-und-2").click
    @driver.find_element(:id, "edit-field-category-und-3").click
    @driver.find_element(:id, "edit-field-category-und-4").click
    @driver.find_element(:id, "edit-field-tags-und").clear
    @driver.find_element(:id, "edit-field-tags-und").send_keys "noway"
    @driver.find_element(:id, "edit-field-blog-or-news-und-blog").click
    @driver.find_element(:id, "edit-submit").click
    assert !60.times{ break if (element_present?(:xpath, "//ul[@id='admin-menu-icon']/li/a/span") rescue false); sleep 1 }
    @driver.find_element(:xpath, "//ul[@id='admin-menu-icon']/li/a/span").click
    assert_equal "ohai", @driver.find_element(:xpath, "//div[@id='content']/div/div/div[3]/div/div/ul/li/h2").text
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
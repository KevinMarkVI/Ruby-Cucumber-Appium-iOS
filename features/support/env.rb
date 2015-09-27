require 'appium_lib'
require 'sauce_whisk'

Before do | scenario |
  # need to configure env variables for browser
  caps = {
    caps: {
      platformVersion: "#{ENV['platformVersion']}",
      deviceName: "#{ENV['deviceName']}",
      platformName: "#{ENV['platformName']}",
      deviceOrientation: 'portrait',
      app: 'https://s3.amazonaws.com/appium/TestApp-iphoneos.app.zip',
      name: "#{scenario.feature.name} - #{scenario.name}"
    }
  }

  @driver = Appium::Driver.new(caps)
  @driver.start_driver
end

# "after all"
After do | scenario |
  @driver.driver_quit

  sessionid =  @driver.session_id

  if scenario.passed?
    SauceWhisk::Jobs.pass_job sessionid
  else
    SauceWhisk::Jobs.fail_job sessionid
  end
end

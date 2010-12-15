# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Uw::Application.initialize!

DateColumn = Car.columns.find{|c| c.name=="valid_from"}


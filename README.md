# Data Store Gem (Ruby)

This Gem is used as a client end point to Create, Read and Delete the Key-Value from the Data Store.

## Compatibility

This Gem is developed under MacOS with ruby version - 2.6.3p62.

This Gem assumes that ruby is already installed in the system.

## Local development

To install the Gem, first bclone it locally by using the git clone command
```
git clone https://github.com/ChintuKarthi/data_store_gem
```
Once cloned, the follow the steps mentioned below to install the gem locally.

Step 1: cd to the cloned repo.
```
cd data_store_gem
```
Step 2: Install gem dependencies by running following command.
```
bundle install
```
This will install the required gem for our client from rubygems.org

Step 3: Run the below command to load the gem.
```
gem build data_store.gemspec
```
This command loads the latest gem changes.

Step 4: Run the below command from the gem root directory to install the gem locally
```
gem install ./data_store_gem-1.0.0.gem
```
Now the Gem is installed in your local successfully.


## Accessing Data Store Gem

To Access the client, go to the terminal(Mac) and run the following command to access the irb
```
irb
```
From here, we need to require the Gem to use start using it's features. It can be done by running the below command
```
require 'data_store_gem'
```
Next step is setting up the optional file path.
If needed it can be set, else it will take the same directory where the gem is installed.

Our client End point is the below one
```
DataStore::KeyValue.#{method_name}
```
the method_name is replaced by the end points the user wishes to access.

# Setting up the File Path

  To set the file path, the following end point is used.
  ```
  DataStore::KeyValue.file_path(path)
  ```
  Where the path is the variable which is the local directory path followed by the file name at the end.
  ```
  example: '/Users/username/Desktop/test/test.pstore'
  ```
  Calling this end point will over ride the default file path.

# Creating the Key-Value

  To create the Key-Value the the following end point is used.
  ```
  DataStore::KeyValue.create(key,value)
  ```
  Where 'key' is a string and value is a JSON object.
  If any value other than the specified format is given, appropriate error message is thrown.

  To set the time_to_live property, include it in the below mentioned format of the value.
  ```
  key = 'test'
  value = {
  	test: 'some_value',
  	time_to_live: 100
  }

  Note: time_to_live is an integer and it is assumed in terms of seconds.
  ```
  Correct value will create the Key-Value in the Data Store.

# Fetching the Key-Value
  
  To read the value from the Data Store, key is used in the end point.
  ```
  DataStore::KeyValue.fetch(key)

  example: key = 'test'
  ```
  Note:
    It assumes the key is already there in the data store. If not appropriate error message is thrown.
    If time_to_live property is set and expired, the key won't be accessible to read the value.


# Delete the Key-Value
  
  To delete the value from the Data Store, key is used in the end point.
  ```
  DataStore::KeyValue.delete(key)
  example: key = 'test'
  ```
  Note:
    It assumes the key is already there in the data store. If not appropriate error message is thrown.
    If time_to_live property is set and expired, the key won't be accessible to delete the value.

# Test Cases
  The gem 'rspec' handles all the test cases written under the spec folder.
  To run the test cases, run the following command from the root directory of the gem.
  ```
    rspec spec
  ```
  This command will trigger all the test cases under the spec folder.
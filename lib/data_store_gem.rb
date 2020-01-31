require 'pstore'
require 'time'

module DataStore
  class KeyValue
  	MAX_VALUE_SIZE = 16384 # 16 KB in Bytes
  	MAX_KEY_SIZE = 32 # 32 Characters
  	MAX_FILE_SIZE = 1073741824 # 1 GB in Bytes
  	@@path_value = "key_value.pstore"
  	def initialize(path)
  		if !path.nil?
  			@@path_value = path
  		end
  		@@data_store = PStore.new(@@path_value)
  	end
  	#sets the file path of user choice.
  	def self.file_path(path)
  		DataStore::KeyValue.new(path)
  		puts "Default file path is changed successfully to #{@@path_value}"
  	end
  	@@data_store = PStore.new(@@path_value)

    # Creates a new key-value in the data store
    # given_key = key of string type
    # given_value = JSON value
    def self.create(given_key, given_value)
    	value_size = given_value.to_s.bytesize
    	key_size = given_key.size
    	unless given_key.is_a? String
    		raise StandardError.new "Given key is not a string. Expected string type"
    	end
    	unless given_value.is_a?(Hash)
    		raise StandardError.new "Given value is not a JSON. Expected JSON Object"
    	end
    	# created_at is appended internally to the value object for using in calculating the time_to_live property
    	created_at = {
    		"created_at": Time.now
    	}
    	given_value = given_value.merge(created_at)
    	if(value_size > MAX_VALUE_SIZE)
    		raise StandardError.new "Value size cannot be more than 16KB"
    	end
    	if(key_size > MAX_KEY_SIZE)
    		raise StandardError.new "Key size cannot be more than 32 Characters"
    	end
    	if File.file?(@@path_value)
    	  file_size = File.size(@@path_value)
    	  if(file_size >= MAX_FILE_SIZE)
	    		raise StandardError.new "File size cannot be more than 1GB"
	    	end
	    end
    	key_existence = check_key(given_key)
    	if !key_existence
		  	@@data_store.transaction do
				  # Saving the Key-Value in the DataStore.
				  @@data_store[given_key] = given_value
				  puts "The Key-Value for this key: #{given_key} is created successfully"
				end
			end
    end

    # Reads value from the data store and gives the JSON response if the key exists in data store
    def self.fetch(search_key)
		  @@data_store.transaction do
			  if @@data_store[search_key]
			  	live_property = check_existence(search_key, @@data_store[search_key])
			  	if live_property
			      return @@data_store[search_key]
			    else
			    	raise PStore::Error, format("This key: '%s' is expired. Not accessible for read", search_key)
			    end
			  else
			  	raise PStore::Error, format("This key: '%s' isn't available in the data store.", search_key)
			  end
			end
		end

		# Checks if the given key exists in data store and throws error. Else returns false
    def self.check_key(given_key)
		  @@data_store.transaction do
		  	if @@data_store[given_key]
			    raise PStore::Error, format("This key: '%s' already exists in the data store.", given_key)
			  else
			  	return false
			  end
			end
		end

		# Deletes the given key from the data store 
		def self.delete(delete_key)
			@@data_store.transaction do
			  if @@data_store[delete_key]
			  	live_property = check_existence(delete_key, @@data_store[delete_key])
			  	if live_property
			      @@data_store.delete(delete_key)
			    	puts "This key: #{delete_key} is deleted successfully"
			    else
			    	raise PStore::Error, format("This key: '%s' expired. Not accessible for delete", delete_key)
			    end
			  else
			  	raise PStore::Error, format("This key: '%s' isn't available in the data store.", delete_key)
			  end	
			end
		end

		# checks the time to live property and returns false if it is expired.
		def self.check_existence(existing_key, value)
			existence = Time.now - value[:created_at]
			if value[:time_to_live]
				if existence <= value[:time_to_live]
				  true
				else
					false
				end
			else
			  true
			end
		end
  end
end
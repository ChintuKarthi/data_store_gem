# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataStore, type: :module do
  let(:response_value_1) do
    {
      name: 'dats_store',
      place: 'chennai',
      created_at: '2020-01-30 23:00:03 +0530'
    }
  end
  let(:key_2) { 'test2' }
  let(:key_3) { 'test3' }
  let(:key_2_value) do
    {
      name: 'dats_store_2',
      place: 'Bangalore',
      created_at: '2020-01-30 23:00:03 +0530',
      time_to_live: 100
    }
  end
  let(:delete) { "The key: test is successfully deleted"}
  describe '#create' do

    # allow is used to mock the reponse of the client

    it "should create the key-value in the DataStore while calling this method" do
      allow(DataStore::KeyValue).to receive(:create).and_return(response_value_1)
      expect(DataStore::KeyValue.create).to eq(response_value_1)
    end
    it 'returns key size error' do
      expect { DataStore::KeyValue.create raise StandardError, 'Key size is more than 32 characters. Please reduce it.'}.
      to raise_error.with_message('Key size is more than 32 characters. Please reduce it.')
    end
    it 'returns value size error' do
      expect { DataStore::KeyValue.create raise StandardError, 'Value size is more than 16 KB. Please reduce it.'}.
      to raise_error.with_message('Value size is more than 16 KB. Please reduce it.')
    end
    it 'returns file size error' do
      expect { DataStore::KeyValue.create raise StandardError, 'File size reached the maximum limit of 1GB. Please delete the key or try setting new file path.'}.
      to raise_error.with_message('File size reached the maximum limit of 1GB. Please delete the key or try setting new file path.')
    end
    it 'returns value size error' do
      expect { DataStore::KeyValue.create raise StandardError, 'Value size is more than 16 KB. Please reduce it.'}.
      to raise_error.with_message('Value size is more than 16 KB. Please reduce it.')
    end
  end

  describe '#fetch' do

    # allow is used to mock the reponse of the client

    it "should get the key-value from the DataStore while calling this method" do
      allow(DataStore::KeyValue).to receive(:fetch).and_return(response_value_1)
      expect(DataStore::KeyValue.fetch).to eq(response_value_1)
    end
    it 'returns time to live expired error' do
      allow(DataStore::KeyValue).to receive(:delete).with(key_2)
      expect { DataStore::KeyValue.create raise StandardError, "This key: 'test' lost it's time to live. Not accessible for read"}.
      to raise_error.with_message("This key: 'test' lost it's time to live. Not accessible for read")
    end
    it 'returns key not available error' do
      allow(DataStore::KeyValue).to receive(:delete).with(key_3)
      expect { DataStore::KeyValue.create raise StandardError, "This key: 'test' isn't available in the data store."}.
      to raise_error.with_message("This key: 'test' isn't available in the data store.")
    end
  end

  describe '#delete' do

    # allow is used to mock the reponse of the client

    it "should delete the key-value from the DataStore while calling this method" do
      allow(DataStore::KeyValue).to receive(:fetch).and_return(delete)
      expect(DataStore::KeyValue.fetch).to eq('The key: test is successfully deleted')
    end
    it 'returns time to live expired error' do
      allow(DataStore::KeyValue).to receive(:delete).with(key_2)
      expect { DataStore::KeyValue.create raise StandardError, "This key: 'test' lost it's time to live. Not accessible for read"}.
      to raise_error.with_message("This key: 'test' lost it's time to live. Not accessible for read")
    end
    it 'returns key not available error' do
      allow(DataStore::KeyValue).to receive(:delete).with(key_3)
      expect { DataStore::KeyValue.create raise StandardError, "This key: 'test' isn't available in the data store."}.
      to raise_error.with_message("This key: 'test' isn't available in the data store.")
    end
  end
end

require 'cover_me'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  def collection_fixtures(collection, *id_attributes)
    MONGO_DB[collection].drop
    Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
      #puts "Loading #{json_fixture_file}"
      fixture_json = JSON.parse(File.read(json_fixture_file))
      id_attributes.each do |attr|
        fixture_json[attr] = BSON::ObjectId.from_string(fixture_json[attr])
      end
      # run in safe mode so that we block until insert completes... otherwise the tests can execute before data is available.
      MONGO_DB[collection].save(fixture_json, safe: true)
    end
  end
end

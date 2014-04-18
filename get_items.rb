require 'pp'
require 'json'

require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

require 'mongo'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def insert_db(items) 
  client = Mongo::MongoClient.new
  db = client.db('gplus')
  col = db.collection('items')

  count = 0

  for item in items do
    if(col.find('id' => item['id']).count() > 0) then
      #puts 'found'
    else
      col.insert(item)
      count += 1
    end
  end
  puts 'total: ' + items.length.to_s + ' inserted: ' + count.to_s 
  client.close
  return count == items.length
end

def get_item(user_id, max_results=10)
  client = Google::APIClient.new(
    :application_name => 'Example Ruby application',
    :application_version => '1.0.0',
    :authorization => nil
  )

  plus = client.discovered_api('plus')

  client.key = 'AIzaSyBXLVoXHG3lLh6xd3PXpTwg77Z_4JRvryg'

  nextPageToken = nil
  res = {}
  old_next_page_token = nil

  while true do
    result = client.execute(
      :api_method => plus.activities.list,
      :parameters => {'collection' => 'public', 'userId' => user_id, 
        "maxResults" => max_results, "pageToken" => old_next_page_token}
    )

    res = JSON.parse(result.body)

    puts res["nextPageToken"]

    break if insert_db(res["items"]) != true 

    old_next_page_token = res['nextPageToken']
    break if old_next_page_token == nil

  end
end

filename = ARGV[0]

fp_json = nil
open(filename,'r'){|fp|
  fp_json = JSON.parse(fp.read)
}

fp_json['people'].each do |item|
  p item['id']
  p item['name']
  get_item(item['id'], 100)
end

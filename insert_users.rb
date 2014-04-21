require 'json'
require 'mongo'

client = Mongo::MongoClient.new
db = client.db('gplus')

while line = gets
    item = JSON.parse(line)
    col_name = item['actor']['id']

    if !db.collection_names.include?(col_name)
    	db.create_collection(col_name)
    end

    col = db.collection(col_name)

    col.insert(item)

    puts col_name
end
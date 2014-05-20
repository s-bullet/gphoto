require 'json'
require 'mongo'

client = Mongo::MongoClient.new
db = client.db('gplus')
collection_names = db.collection_names

while line = gets
    item = JSON.parse(line)
    col_name = item['actor']['id']

    puts col_name
    puts collection_names

    if !collection_names.include?(col_name)
    	db.create_collection(col_name)
        collection_names.push(col_name)
    end

    col = db.collection(col_name)

    col.insert(item)

    puts col_name
end

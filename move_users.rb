require 'json'
require 'mongo'

client = Mongo::MongoClient.new
db = client.db('gplus')
collection_names = db.collection_names

items = db.collection('items')

items.find.each {|row|
  id = row['actor']['id']
  if !collection_names.include?(id)
    db.create_collection(id)
    collection_names.push(id)
  end

  col = db.collection(id)

  col.insert(row)
  puts row['id']
}


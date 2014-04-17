require 'json'
filename = ARGV[0]

fp_json = nil
open(filename,'r'){|fp|
  fp_json = JSON.parse(fp.read)
}

fp_json['people'].each do |item|
  p item['id']
  p item['name']
end

require 'rubygems'
require 'httpclient'
require 'hpricot'
require 'pp'

URL = 'http://ameblo.jp/mogatanpe/entry-11847797008.html'

hc = HTTPClient.new('','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.29.13 (KHTML, like Gecko) Version/6.0.4 Safari/536.29.13')

header = {'Accept-Language' => 'ja'}

html = hc.get_content(URL, nil, header)

#puts html

doc = Hpricot(html)
puts doc/"a.next"

#(doc/"div.insertPrSpace").remove
#(doc/"div#themeImageBox").remove
#(doc/"ul#exLinkBtn").remove
#(doc/"div.adsense").remove
#sub_contents = ((doc/"div.subContents")/"div")[0].inner_html
imgs = (((doc/"div.subContents")/"div")/"a.detailOn")/"img"

imgs.each {|img|
  puts img["src"]
}


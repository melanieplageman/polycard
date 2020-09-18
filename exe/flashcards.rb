require "bundler/setup"
require 'http'
require 'json'
# require 'optparse'

class Card 
end

class Side
  def initialize(content)
    @content = content 
  end

  def to_json 
    JSON.generate({ :content => @content })
  end
end

def new_card(args)
  response = HTTP.post("http://localhost:8080/card") 
  card_id = JSON.parse(response.body)['id']
  add_side([card_id, *args])
  puts card_id
end

def add_side(args)
  card_id, *args = args
  args.map do |side_content|
    Side.new(side_content)
  end.each do |side|
    response = HTTP.post("http://localhost:8080/card/#{card_id}/side", :body => side.to_json)

    puts JSON.parse(response.body)
  end
end

command, *args = ARGV
if command == 'new'
  new_card(args)
elsif command == 'add'
  add_side(args)
else
  fail "Unrecognized command #{command.inspect}"
end



# response = HTTP.get("http://localhost:8080/card/#{id}")

# response = HTTP.put("http://localhost:8080/card/#{id}", :body => card.to_json)

# response = HTTP.delete("http://localhost:8080/card/#{id}") 
#
#
#

# options = {}
# OptionParser.new do |opts|
#   opts.banner = "Usage: cards.rb [options]"

#   opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
#     options[:verbose] = v
#   end
# end.parse!

# options.each do |o|
#   puts o
# end

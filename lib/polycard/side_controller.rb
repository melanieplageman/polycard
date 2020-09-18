require 'sinatra'
require 'polycard/database'

class SideApp < Sinatra::Base
  set :show_exceptions, :after_handler
  set :logging, true

  error Sequel::NoMatchingRow do |e|
    if e.respond_to?(:pk)
      halt 404, "No side with id #{e.pk}"
    else
      halt 404, 'No side'
    end
  end

  error Sequel::ForeignKeyConstraintViolation do
    halt 404, "Card not found"
  end

  # R - Retrieve
  get '/side/:id' do |id|
    @side = Side.with_pk!(id)
    @next_side = @side.next
    erb :side
  end

  # C - Create
  post '/card/:card_id/side' do |card_id|
    side = JSON.parse(request.body.read)
    side_content = side["content"]
    side_id = Side.insert(card_id: card_id, content: side_content)
    response = {side_id: side_id, side_content: side_content}
    headers "Location" => "/card/#{card_id}/side/#{side_id}"
    body response.to_json
  end

  # D - Delete
  delete '/side/:id' do |side_id|
    side = Side[side_id]
    if side.nil?
      halt 404, 'Side not found'
    end
    side.delete
    'Deleted side.'
  end

  # U - update (to update a card, use multiple PUT sides)
  put '/side/:id' do |side_id|
    side = Side[side_id]
    if side.nil?
      halt 404, 'Side not found'
    end
    updated_side = JSON.parse(request.body.read)
    updated_content = updated_side["content"]
    Side[side_id].update(content: updated_content)
    response = {content: updated_content}
    response.to_json
  end
end

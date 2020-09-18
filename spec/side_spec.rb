ENV['APP_ENV'] = 'test'

require 'polycard/side_controller'
require 'polycard/card_controller'
require 'rack/test'

describe SideApp do
  include Rack::Test::Methods
  def app
    SideApp 
  end

  before do
    Deck.truncate(cascade: true)
    Card.truncate(cascade: true)
  end

  describe 'GET /side/:id' do
    it "Retrieves a side given a valid side locator" do
      deck_id = Deck.insert(name: 'test_deck')
      card_id = Card.insert(deck_id: deck_id)
      side_id = Side.insert(card_id: card_id, content: 'something')
      get("/side/#{side_id}")
      expect(last_response.status).to eq(200)
    end

    it 'Fails with 404 if the side does not exist' do
      get('/side/1234')
      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq('No side with id 1234')
    end
  end

  describe 'POST /card/:card_id/side' do
    it "Creates a new side for a card given a valid card id" do
      deck_id = Deck.insert(name: 'test_deck')
      card_id = Card.insert(deck_id: deck_id)
      body = { content: 'something' } 
      post("/card/#{card_id}/side", body.to_json)
      expect(last_response.status).to eq(200)
      side_id = JSON.parse(last_response.body)["side_id"]
      side_content = JSON.parse(last_response.body)["side_content"]
      expect(side_content).to eq(body[:content])
      ds_side = Side[side_id]
      expect(ds_side.content).to eq(side_content)
    end

    it "Fails with 404 if the card does not exist" do
      body = { content: 'something' } 
      post("/card/1234/side", body.to_json)
      expect(last_response.status).to eq(404)
    end
  end

  describe 'DELETE /side/:id' do
    it "Deletes a side given a valid side locator" do
      deck_id = Deck.insert(name: 'test_deck')
      card_id = Card.insert(deck_id: deck_id)
      side_id = Side.insert(card_id: card_id, content: "something")
      delete("/side/#{side_id}")
      expect(Side[side_id]).to be(nil)
      expect(last_response.body).to eq('Deleted side.')
    end

    it 'Fails with 404 if the side does not exist' do
      delete('/side/1234')
      expect(last_response.status). to eq(404)
    end
  end

  describe 'PUT /side/:id' do
    it 'Updates an existing side given a valid side locator' do
      deck_id = Deck.insert(name: 'test_deck')
      card_id = Card.insert(deck_id: deck_id)
      side_id = Side.insert(card_id: card_id, content: 'something')
      body = { content: 'something_else' } 
      put("/side/#{side_id}", body.to_json)
      side_content = JSON.parse(last_response.body)["content"]
      expect(side_content).to eq(body[:content])
      expect(Side[side_id].content).to eq(body[:content])
    end
  end
end

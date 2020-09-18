DROP TABLE IF EXISTS deck CASCADE;
CREATE TABLE deck (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  name TEXT NOT NULL
);

-- TODO: this doesn't work
CREATE OR REPLACE FUNCTION trigger_func_default_ordering_id()
  RETURNS trigger
  LANGUAGE plpgsql AS
$func$
BEGIN
  NEW.ordering_id := NEW.id;
  RETURN NEW;
END
$func$;

CREATE TRIGGER card_default_ordering_id
AFTER INSERT ON card
FOR EACH ROW
  EXECUTE PROCEDURE trigger_func_default_ordering_id();

DROP TABLE IF EXISTS card CASCADE;
CREATE TABLE card (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  deck_id INTEGER REFERENCES deck(id) ON DELETE CASCADE,
  ordering_id INTEGER
  --ordering_id INTEGER NOT NULL CHECK (ordering_id > 0)
);

DROP TABLE IF EXISTS side;
CREATE TABLE side (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  card_id INTEGER REFERENCES card(id) ON DELETE CASCADE,
  --ordering_id INTEGER NOT NULL CHECK (ordering_id > 0),
  ordering_id INTEGER,
  content TEXT NOT NULL,
  content_type TEXT NOT NULL DEFAULT 'text' CHECK (content_type IN ('text', 'ruby'))
);

DROP TABLE IF EXISTS practice_session CASCADE;
CREATE TABLE practice_session (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  -- TODO: I want to have a value for deck_id to indicate that that deck was deleted
  -- however, I don't want that to be the default when a practice session is created
  -- without a deck, I want that to be an error
  deck_id INTEGER REFERENCES deck(id) ON DELETE NO ACTION 
);

DROP TABLE IF EXISTS practice_item;
CREATE TABLE practice_item (
  id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
  practice_session_id INTEGER REFERENCES practice_session(id) ON DELETE CASCADE,
  -- TODO: I want to have a value for card_id to indicate that that the card was deleted
  -- however, I don't want that to be the default when a practice item is created
  -- without a card, when a practice_item is created without one, I want that to be an error
  card_id INTEGER REFERENCES card(id) ON DELETE NO ACTION,
  status TEXT NOT NULL
);

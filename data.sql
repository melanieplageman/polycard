TRUNCATE card CASCADE;

INSERT INTO deck(id, name) VALUES
  (1, 'super fun deck'),
  (2, 'learning ruby');

INSERT INTO card(id, deck_id) VALUES
  (1, 1),
  (2, 1),
  (3, 1),
  (4, 1);

INSERT INTO side(card_id, content, content_type) VALUES
  (1, 'make a flashcard class', 'text'),
  (1, 'class FlashcardApp ; end', 'ruby'),
  (2, 'check if a variable is nil', 'text'),
  (2, 'variable.nil?', 'ruby'),
  (3, 'what is a homoiconic language', 'text'),
  (3, 'hard question', 'text'),
  (4, 'make a dictionary', 'text'),
  (4, 'mydict = { ''key'' => ''value'', ''key2'' => ''value2'' }', 'ruby');

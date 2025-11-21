-- Fix sort_order values - Guessing Game should be first
UPDATE games SET sort_order = 1 WHERE slug = 'guessing-game';
-- Card Game should be second
UPDATE games SET sort_order = 2 WHERE slug = 'card-game';


-- Rename dual-voice display labels: Benedict → Cleo, Blanchett → Milo
-- Storage paths (…/benedict.mp3, …/blanchett.mp3) are unchanged.

UPDATE audio_voice_variants
SET voice_label = 'Cleo', updated_at = NOW()
WHERE voice_label = 'Benedict';

UPDATE audio_voice_variants
SET voice_label = 'Milo', updated_at = NOW()
WHERE voice_label = 'Blanchett';

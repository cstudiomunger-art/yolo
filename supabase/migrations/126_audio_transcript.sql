-- Narration script (解说词) for audio guides and sub-area audio.
-- One Markdown transcript per parent record; shared across all voice variants.

ALTER TABLE audio_guides ADD COLUMN IF NOT EXISTS transcript TEXT;
ALTER TABLE sub_areas   ADD COLUMN IF NOT EXISTS audio_transcript TEXT;

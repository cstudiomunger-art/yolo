-- Sub-area: single rich-text body (replaces content_blocks list in CMS)

ALTER TABLE sub_areas ADD COLUMN IF NOT EXISTS body TEXT;

CREATE OR REPLACE FUNCTION public.sub_area_blocks_to_html(blocks jsonb)
RETURNS text
LANGUAGE plpgsql
IMMUTABLE
AS $$
DECLARE
  elem jsonb;
  result text := '';
  btype text;
  t text;
  b text;
  img text;
BEGIN
  IF blocks IS NULL OR jsonb_typeof(blocks) <> 'array' THEN
    RETURN '';
  END IF;
  FOR elem IN SELECT value FROM jsonb_array_elements(blocks)
  LOOP
    btype := lower(COALESCE(elem->>'type', ''));
    t := COALESCE(elem->>'title', '');
    b := COALESCE(elem->>'body', '');
    img := COALESCE(elem->>'imagePath', elem->>'image_path', '');
    IF btype = 'heading' OR (t <> '' AND b = '' AND img = '') THEN
      IF t <> '' THEN
        result := result || '<h2>' || replace(replace(t, '&', '&amp;'), '<', '&lt;') || '</h2>';
      END IF;
    ELSIF btype = 'image' OR img <> '' THEN
      IF img = '' THEN
        img := b;
      END IF;
      IF img <> '' THEN
        result := result || '<p><img src="' || replace(img, '"', '%22') || '" alt=""></p>';
        IF t <> '' THEN
          result := result || '<p><em>' || replace(replace(t, '&', '&amp;'), '<', '&lt;') || '</em></p>';
        END IF;
      END IF;
    ELSE
      IF b <> '' THEN
        IF b LIKE '<%' THEN
          result := result || b;
        ELSE
          result := result || '<p>' || replace(replace(b, '&', '&amp;'), '<', '&lt;') || '</p>';
        END IF;
      ELSIF t <> '' THEN
        result := result || '<p>' || replace(replace(t, '&', '&amp;'), '<', '&lt;') || '</p>';
      END IF;
    END IF;
  END LOOP;
  RETURN result;
END;
$$;

UPDATE sub_areas
SET body = public.sub_area_blocks_to_html(content_blocks)
WHERE COALESCE(trim(body), '') = ''
  AND content_blocks IS NOT NULL
  AND content_blocks <> '[]'::jsonb;

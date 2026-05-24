-- Rebrand display defaults: ChinaGo → YOLO HAPPY (only when still on legacy values)
UPDATE app_settings SET about_title = 'YOLO HAPPY' WHERE id = 'global' AND about_title = 'ChinaGo';
UPDATE app_settings SET iap_pro_title = 'YOLO HAPPY Pro' WHERE id = 'global' AND iap_pro_title = 'ChinaGo Pro';
UPDATE app_settings SET paywall_pro_title = 'YOLO HAPPY Pro' WHERE id = 'global' AND paywall_pro_title = 'ChinaGo Pro';

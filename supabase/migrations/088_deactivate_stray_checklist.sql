-- 停用遗留测试清单项 cl_first（title_en='first'，无正文，绑 beijing）
-- 它会在任何含北京的行程里多出一条空白 "first" 项。087 停用名单未包含它，补此一条。
UPDATE checklist_items
SET is_active = FALSE, updated_at = NOW()
WHERE id = 'cl_first';

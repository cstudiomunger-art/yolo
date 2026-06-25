-- 行前清单：每条「提前提醒天数」reminder_days_before
-- App 在 出发日 − N 天 的 9:00 推送该条提醒（仅对适用且未完成的条目）。留空 = 不单独提醒。
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS reminder_days_before INT;

COMMENT ON COLUMN checklist_items.reminder_days_before IS
  '出发前 N 天提醒（本地通知）。NULL = 不单独提醒，仍受全局 checklist_settings 提醒覆盖。';

-- 回填 v1 文档给定的提醒天数（其余条目保持 NULL）
UPDATE checklist_items SET reminder_days_before = 30, updated_at = NOW() WHERE id = 'cl_entry_visa_eligibility';
UPDATE checklist_items SET reminder_days_before = 45, updated_at = NOW() WHERE id = 'cl_entry_passport_validity';
UPDATE checklist_items SET reminder_days_before = 3,  updated_at = NOW() WHERE id = 'cl_pay_alipay';
UPDATE checklist_items SET reminder_days_before = 3,  updated_at = NOW() WHERE id = 'cl_pay_wechat';
UPDATE checklist_items SET reminder_days_before = 5,  updated_at = NOW() WHERE id = 'cl_conn_esim';
UPDATE checklist_items SET reminder_days_before = 15, updated_at = NOW() WHERE id = 'cl_book_train_tickets';
UPDATE checklist_items SET reminder_days_before = 10, updated_at = NOW() WHERE id = 'cl_book_attractions';
UPDATE checklist_items SET reminder_days_before = 7,  updated_at = NOW() WHERE id = 'cl_cd_prebook_attractions';

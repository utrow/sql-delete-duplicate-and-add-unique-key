-- ユニークキーの追加
ALTER TABLE `xxx_table` ADD CONSTRAINT `uniq_user_id_liked_user_id`
    UNIQUE (`user_id`, `liked_user_id`);

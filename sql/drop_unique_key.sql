-- ユニークキー削除のため、一時的に外部キーを削除
ALTER TABLE `xxx_table` DROP FOREIGN KEY `fk_xxx_table_user_id`;
ALTER TABLE `xxx_table` DROP FOREIGN KEY `fk_xxx_table_liked_user_id`;

-- ユニークキーの削除
ALTER TABLE `xxx_table` DROP INDEX `uniq_user_id_liked_user_id`;

-- 外部キーを再度追加
ALTER TABLE `xxx_table` ADD CONSTRAINT `fk_xxx_table_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
ALTER TABLE `xxx_table`  ADD CONSTRAINT `fk_xxx_table_liked_user_id`
    FOREIGN KEY (`liked_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

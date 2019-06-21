# ユニークキーの追加・削除のクエリ

ここでは、ユニークキーは複数カラムをキーとします。

## ユニークキーを後から追加する作業

- まず、前処理が必要で、既にユニークでないレコードが存在している可能性があるため、削除する
    - 重複するものがあれば、一番古いものを残して、他を削除する
    - `delete_duplicate.sql`
```sql
DELETE `xxx_table`
FROM `xxx_table`

-- 重複するお気に入りユーザを取得する
INNER JOIN (

	SELECT `user_id`, `liked_user_id`, count(*) `count`
	FROM `xxx_table`
	GROUP BY `user_id`, `liked_user_id`
	HAVING `count` > 1

) `duplicates`
ON
    `xxx_table`.`user_id` = `duplicates`.`user_id` AND
    `xxx_table`.`liked_user_id` = `duplicates`.`liked_user_id`

-- 最初のお気に入りユーザを取得する
LEFT JOIN (

    SELECT MIN(`id`) `min_id`
    FROM `xxx_table`
    GROUP BY `user_id`, `liked_user_id`

) `first_block`
ON `xxx_table`.`id` = `first_block`.`min_id`

-- 最初のお気に入りユーザを除外する
WHERE `first_block`.`min_id` IS NULL;

```

- それから、ユニークキーの追加
    - `add_unique_key.sql`
```sql
-- ユニークキーの追加
ALTER TABLE `xxx_table` ADD CONSTRAINT `uniq_user_id_liked_user_id`
    UNIQUE (`user_id`, `liked_user_id`);

```

## ユニークキーを削除する作業
- 外部キー制約が設定されている場合、`DROP INDEX`するだけでは削除できなかったので、その点の対応が必要
    - `drop_unique_key.sql`
```sql
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
```

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

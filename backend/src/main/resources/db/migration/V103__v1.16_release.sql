-- 新增字段
ALTER TABLE `swagger_url_project`
    ADD COLUMN `config` longtext COMMENT '鉴权配置信息' AFTER `mode_id`;

-- 第三方平台模板
ALTER TABLE project
    ADD platform varchar(20) DEFAULT 'Local' NOT NULL COMMENT '项目使用哪个平台的模板';
ALTER TABLE project
    ADD third_part_template tinyint(1) DEFAULT 0 NULL COMMENT '是否使用第三方平台缺陷模板';

-- 处理历史数据
UPDATE issue_template SET platform = 'Local' WHERE platform = 'metersphere';
UPDATE project p JOIN issue_template it on p.issue_template_id = it.id SET p.platform = it.platform;
UPDATE custom_field SET `type` = 'date' WHERE `type` = 'data';

-- 公共用例库
ALTER TABLE project
    ADD case_public tinyint(1) DEFAULT NULL COMMENT '是否开启用例公共库';
ALTER TABLE project
    ADD api_quick varchar(50) DEFAULT NULL COMMENT 'api定义快捷调试按钮';

ALTER TABLE test_case
    ADD case_public tinyint(1) DEFAULT NULL COMMENT '是否是公共用例';

-- 执行结果优化
alter table api_scenario_report add report_version int null;

CREATE TABLE IF NOT EXISTS `api_scenario_report_result`
(
    `id` varchar(50) NOT NULL COMMENT 'ID',
    `resource_id` VARCHAR(200) DEFAULT NULL COMMENT '请求资源 id',
    `report_id` VARCHAR(50) DEFAULT NULL COMMENT '报告 id',
    `create_time` bigint(13)  NULL COMMENT '创建时间',
    `status` varchar(100) null COMMENT '结果状态',
    `request_time` bigint(13) null COMMENT '请求时间',
	`total_assertions` bigint(13) null COMMENT '总断言数',
    `pass_assertions` bigint(13) null COMMENT '失败断言数',
    `content` longblob  COMMENT '执行结果',
    PRIMARY KEY (`id`),
    KEY `index_resource_id` (`resource_id`) USING BTREE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `api_scenario_report_structure`
(
    `id` varchar
(
    50
) NOT NULL COMMENT 'ID',
    `report_id` VARCHAR
(
    50
) DEFAULT NULL COMMENT '请求资源 id',
    `create_time` bigint
(
    13
) NULL COMMENT '创建时间',
    `resource_tree` longblob DEFAULT NULL COMMENT '资源步骤结构树',
    `console` LONGTEXT DEFAULT NULL COMMENT '执行日志',
    PRIMARY KEY
(
    `id`
),
    KEY `index_report_id`
(
    `report_id`
) USING BTREE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;


INSERT INTO user_group_permission (id, group_id, permission_id, module_id)
VALUES (UUID(), 'project_app_manager', 'PROJECT_APP_MANAGER:READ+EDIT', 'PROJECT_APP_MANAGER');
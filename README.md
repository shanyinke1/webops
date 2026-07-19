# webops - 网站开发部署工具库

> 所有内部工具、脚本、自动化任务统一放这里。开发→部署→运维全流程工具集。

## 目录结构

```
webops/
├── README.md              # 本文件
├── RULES.md               # 规则说明
├── seo/                   # SEO工具
│   ├── sitemap/           # sitemap生成脚本
│   ├── baidu_push/        # 百度自动推送
│   └── robots.txt         # 各站robots.txt模板
├── deploy/                # 部署脚本
│   ├── pull_all.sh        # 一键git pull所有站
│   └── sync_webroot.sh    # 同步到生产webroot
├── monitor/               # 监控巡检脚本
│   ├── check_all.sh       # 全站巡检
│   └── report.sh          # 生成巡检报告
├── backup/                # 备份脚本
│   └── db_backup.sh       # 数据库备份
└── docs/
    └── workflow.md        # 工作流程文档
```

## 规则

### 1. 脚本命名
- 所有脚本带站名前缀，如 `seo_sitemap_xianheng.sh`
- 脚本开头必须有说明注释（用途、用法、依赖）

### 2. 部署流程
```
本地/开发机改代码 → git push → 负责人 git pull → 部署到webroot → 验证
```

### 3. 脚本归属
- **小飞**：seo/、deploy/、monitor/
- **小腾**：负责小腾站群（xianheng/myarticle/sxzpw/e0575/nav/omni/admin）
- **小马**：负责小马站群（shaoda/xiaodou/yuezhou）
- **大麦**：协助测试验证

### 4. 提交规范
```
feat: 新功能
fix: 修复bug
docs: 文档更新
ops: 运维脚本改动
```

### 5. 安全注意
- 所有脚本禁止硬编码密码，用环境变量或配置文件
- 涉及数据库的操作必须先备份

---

*最后更新：2026-07-19 by 小飞*

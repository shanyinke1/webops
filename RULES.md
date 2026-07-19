# webops 使用规则

## 核心原则
1. **改了代码必须立即 push 并通知负责人部署**，不能等老大反复催
2. **不走 SSH 直接连别人服务器**，通过 GitHub 沟通
3. **批量操作前必须先备份**
4. **脚本禁止硬编码密码**，用环境变量或配置文件

## 站群负责人

| 负责人 | 站群 | 仓库 |
|--------|------|------|
| 小腾 | xianheng.org / myarticle.com.cn / sxzpw.cn / e0575.xyz / e0575.org / omni.shanyin.xyz / admin.shanyin.xyz | 各项目仓库 |
| 小马 | shaoda.net / xiaodou.net / yuezhou.org | shaoda-tech |
| 小飞 | 公众号发布脚本、SEO工具、教程站模板 | webops |

## 部署标准流程
```
1. 本地改代码 → git add . && git commit -m "描述"
2. git pull --ff-only origin main（先拉最新）
3. git push origin main
4. 立即 @负责人 部署
5. 负责人 pull → 复制到 webroot → 验证 → 群里报结果
```

## 巡检标准（每日）
每个负责人每天自查自己负责的站：
```bash
for site in 域名1 域名2; do
  echo "=== $site ==="
  curl -s -o /dev/null -w "HTTP:%{http_code} " "https://$site/"
  curl -s -o /dev/null -w "HTTPS:%{http_code} " "https://$site/" -k
  curl -s -o /dev/null -w "track:%{http_code}\n" "https://$site/track.php?path=/"
done
```

## 脚本开发规范
- 脚本文件头注释：`用途 | 用法 | 依赖 | 作者 | 日期`
- 执行权限：`chmod +x script.sh`
- 测试环境先跑通，再 push 部署

---

*最后更新：2026-07-19 by 小飞*

## 安全高压线（2026-07-19 强制执行）

### 危险函数名单
`exec()` `shell_exec()` `system()` `popen()` `passthru()`

### 强制扫描流程
**每次 push 代码前必须执行：**
```bash
grep -rn 'shell_exec\|exec\s*(|system\s*(|popen\s*(' . --include="*.php" | grep -v escapeshellarg
```
- 有输出的一律**不打上线**，必须先修复
- 新增含危险函数的 PHP 文件，必须同时提交 escapeshellarg 保护方案

### 已验证的安全写法
```php
// ✅ 安全：参数来自白名单/固定值
$cmd = "systemctl restart " . escapeshellarg($service);

// ✅ 安全：用 PHP 原生替代 shell 命令
$content = file_get_contents($logFile);
$lines = file($logFile, FILE_IGNORE_NEW_LINES);

// ❌ 危险：用户输入直接拼 shell 命令
$cmd = "tail -n $lines $file"; // 未过滤

// ❌ 危险：即使过滤了也容易出错，用 wrapper
$cmd = "sudo systemctl $action $service"; // action无白名单
```

### wrapper 脚本（必须使用）
- `service-ctrl` — 系统服务管理（nginx/php8.3-fpm/mariadb/redis/supervisor）
- `crons-ctrl` — 定时任务管理
- 所有 systemctl 调用必须走这两个 wrapper，不允许直接拼 shell 命令

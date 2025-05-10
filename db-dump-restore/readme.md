# 备份与恢复

## 定时器

每三十分钟同步一次

```bash
crontab -e
```

```corn
*/30 * * * * /bin/bash /root/e-recycle-env/db-dump-restore/dump.sh >> /root/mongo_backups/mongo_dump.log 2>&1
*/30 * * * * /bin/bash /root/e-recycle-env/db-dump-restore/restore.sh >> /root/mongo_backups/mongo_restore.log 2>&1
```

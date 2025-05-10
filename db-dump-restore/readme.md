# 备份与恢复

## 定时器

每三十分钟同步一次

```bash
crontab -e
```

```corn
*/30 * * * * /bin/bash /home/youruser/mongo_restore.sh >> /home/youruser/mongo_restore.log 2>&1
```

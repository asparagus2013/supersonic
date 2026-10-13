# 本地源码 Docker 部署

使用 Node 20、Maven、Java 17 及以上和 Docker Desktop。先安装 webapp 前端依赖。

在项目根目录构建当前源码：

```sh
bash docker/build-local.sh
```

复制 `docker/.env.local.example` 到 `docker/.env.local`，填写已有 MySQL 的数据库名、用户名和密码。连接地址为 Docker Desktop 宿主机的 3306 端口。MySQL 库应已初始化 SuperSonic 表；当前源码的 MySQL 配置关闭了自动初始化。

```sh
docker compose --env-file docker/.env.local -p supersonic-local -f docker/docker-compose.local.yml up -d
docker compose --env-file docker/.env.local -p supersonic-local -f docker/docker-compose.local.yml logs -f app
```

访问 http://localhost:9080 。修改源码后重新构建，并再次执行 `up -d`。

停止应用（保留现有 MySQL 和日志）：

```sh
docker compose --env-file docker/.env.local -p supersonic-local -f docker/docker-compose.local.yml down
```

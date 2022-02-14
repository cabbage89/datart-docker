### 本地构建

将dataart zip包拷贝到本目录

```
docker build -f local.Dockerfile -t="running-elephant/datart:latest" --build-arg DATART_ZIP=datart-server-1.0.0-beta.0-install.zip .
```

### 极速启动

```
docker-compose up -d
```

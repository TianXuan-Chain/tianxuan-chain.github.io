FROM hub.fuxi.netease.com/danlu/node:18-alpine as builder
WORKDIR '/app'
COPY . .

#运行阶段
FROM hub.fuxi.netease.com/danlu/nginx:alpine
# 使用中科大源
RUN echo -e http://mirrors.ustc.edu.cn/alpine/latest-stable/main/ > /etc/apk/repositories
# 设置时区
ENV TIME_ZONE=Asia/Shanghai
RUN \
  mkdir -p /usr/src/app \
  && apk add --no-cache tzdata \
  && echo "${TIME_ZONE}" > /etc/timezone \
  && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime
COPY --from=builder /app/dist /usr/share/nginx/html

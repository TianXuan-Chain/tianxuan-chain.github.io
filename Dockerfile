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
COPY --from=builder /app /usr/share/nginx/html

# 删除暴露git信息文件
RUN \
cd /usr/share/nginx/html \
&& rm -rf Dockerfile \
&& rm -rf Dockerfile-${TIME_ZONE} \
&& rm -rf LICENSE \
&& rm -rf package.json \
&& rm -rf README.md
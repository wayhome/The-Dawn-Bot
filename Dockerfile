# 第一阶段: 安装系统依赖
FROM python:3.11-slim-buster as builder
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsm6 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

# 第二阶段: 设置应用
FROM python:3.11-slim-buster
WORKDIR /usr/src/app

# 复制第一阶段安装的系统依赖
COPY --from=builder /usr/lib/x86_64-linux-gnu/libSM.so.6 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libXext.so.6 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libICE.so.6 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/bin/ffmpeg /usr/bin/

# 复制项目文件
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DAWN_EMAIL="" \
    DAWN_PASSWORD="" \
    DAWN_2CAPTCHA_KEY="" \
    DAWN_PROXY="" \
    DAWN_MODE="farm"

# 添加启动脚本
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["python", "./run.py"]

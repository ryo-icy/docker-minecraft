# centos7のイメージを使用
FROM centos:centos7

# メタデータ定義
LABEL maintainer="Ryo-icy"
LABEL org.opencontainers.image.source="https://github.com/ryo-icy/docker-minecraft"

# 実行ユーザの設定
ARG UID=1000
RUN useradd -m -u ${UID} minecraft

# メモリ初期設定
ENV MAX_MEM=1G
ENV MIN_MEM=1G

# jarファイル名
ENV JAR_FILE=spigot-1.17.jar

# マインクラフトサーバポート
EXPOSE 25565
# Dynmapポート
# EXPOSE 8123

# パッケージをインストール
RUN yum install -y epel-release wget python3
RUN yum install -y jq
RUN pip3 install yq

# 作業ディレクトリを/binに設定
WORKDIR /bin

# Java16をダウンロード
RUN wget "https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16.0.1%2B9/OpenJDK16U-jdk_x64_linux_hotspot_16.0.1_9.tar.gz"
RUN tar xzf OpenJDK16U-jdk_x64_linux_hotspot_16.0.1_9.tar.gz
RUN ln -s /bin/jdk-16.0.1+9/bin/java /bin/java

# rcon-cliをダウンロード
RUN wget "https://github.com/itzg/rcon-cli/releases/download/1.4.8/rcon-cli_1.4.8_linux_386.tar.gz"
RUN tar xzf rcon-cli_1.4.8_linux_386.tar.gz

# タイムゾーンをJSTに設定
ENV TZ=Asia/Tokyo

# 日本語ロケールに設定
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# rcon-cliのコンフィグを配置
COPY .rcon-cli.yaml /root
COPY .rcon-cli.yaml /home/minecraft

# /minecraftディレクトリを作成
RUN mkdir /minecraft

# 作業ディレクトリを/に設定
WORKDIR /

# start.shを配置
COPY start.sh ./
RUN chmod +x ./start.sh

# minecraft-runnerを配置
COPY minecraft-runner /bin
RUN chmod +x /bin/minecraft-runner

# minecraftユーザに切り替え
USER minecraft

# spigotを起動
ENTRYPOINT ./start.sh

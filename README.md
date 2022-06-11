[![Build and Publish Docker](https://github.com/ryo-icy/docker-minecraft/actions/workflows/build_push.yml/badge.svg)](https://github.com/ryo-icy/docker-minecraft/actions/workflows/build_push.yml)
# docker-minecraft
マインクラフトサーバを稼働させるためDockerファイルです。

## 目次
- [前提](https://github.com/ryo-icy/docker-minecraft#%E5%89%8D%E6%8F%90)
- [超簡単な手順](https://github.com/ryo-icy/docker-minecraft#%E8%B6%85%E7%B0%A1%E5%8D%98%E3%81%AA%E6%89%8B%E9%A0%86)
- [注意点](https://github.com/ryo-icy/docker-minecraft#%E6%B3%A8%E6%84%8F%E7%82%B9)
- [OPの登録方法](https://github.com/ryo-icy/docker-minecraft#op%E3%81%AE%E7%99%BB%E9%8C%B2%E6%96%B9%E6%B3%95)
- [コマンド一覧](https://github.com/ryo-icy/docker-minecraft#%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E4%B8%80%E8%A6%A7)
- [rcon-cliの使い方](https://github.com/ryo-icy/docker-minecraft#rcon-cli%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9)
- [Docker imageのビルド方法](https://github.com/ryo-icy/docker-minecraft#docker-image%E3%81%AE%E3%83%93%E3%83%AB%E3%83%89%E6%96%B9%E6%B3%95)
- [docker-compose.ymlの仕様](https://github.com/ryo-icy/docker-minecraft#docker-composeyml%E3%81%AE%E4%BB%95%E6%A7%98)
- [docker-compose.ymlのパラメータ](https://github.com/ryo-icy/docker-minecraft#docker-composeyml%E3%81%AE%E3%83%91%E3%83%A9%E3%83%A1%E3%83%BC%E3%82%BF)
- [docker-compose.ymlの例](https://github.com/ryo-icy/docker-minecraft#docker-composeyml%E3%81%AE%E4%BE%8B)

## 前提
- docker及びdocker-compose環境。
- sudoが使える環境(※マウントされたデータはroot権限を持っていないと編集できません。回避策はあります。)
- Linuxのコマンドをある程度理解している。

## 超簡単な手順
0. docker-networkを作成する。
```
docker network create minecraft-network
```

1. ソースコードをクローンする。
```
git clone https://github.com/ryo-icy/docker-minecraft.git
```

2. ダウンロードしたファイルの中に移動する。
```
cd docker-spigot-server/
```

3. 手動で`docker-compose.yml`ファイルを書き換える。

| パラメータ | 説明 |
| --- | --- |
| container name | コンテナの名前。一意のものにすること。 |
| host port | 使用するポートを指定する。 |
| min memory | 使用するメモリの最低値を指定する。 |
| max memory | 使用するメモリの最大値を指定する。 |
| jar file | 使用するjarファイル名を指定する。 |

4. `data`ディレクトリを作成する。
```
mkdir data
```

5. `data`ディレクトリにマインクラフトサーバのデータを格納する。
- jarファイルやserver.propertiesなど

6. マインクラフトサーバを起動する。
```
docker-compose up -d
```

## 注意点
- サーバを複数起動する場合は手順3の< container name >を変更する必要がある。
- sudo(root)権限を持っていないと`data`ディレクトリを編集できません。
  
  ※回避するにはビルドする前に`rootless`ディレクトリのファイルに置き換えましょう。
  ※rootless前提で作成していないので、うまく動かない可能性があります。

- マインクラフトサーバのデータは`data`ディレクトリに保存されます。
- docker-compose.ymlと同じディレクトリで起動コマンドを実行する必要がある。
- dynmapを使用する場合はdocker-compose.ymlの`ports:`配下に`- 8123:8123`を追加してください。

例
```yml
    ports:
      - 25565:25565
      - 8123:8123
```


## OPの登録方法
```
docker exec -it <container name> rcon-cli op <player name>
```
例
```
docker exec -it minecraft rcon-cli op ryo_icy
```

## コマンド一覧
| コマンド | 説明 |
| --- | --- |
| docker-compose up -d | コンテナ(マインクラフトサーバ)を起動。<br>--buildオプションを付けるとビルドも実行してくれる。 |
| docker-compose stop | コンテナを停止。 |
| docker-compose build | コンテナをビルドする。|
| docker-compose rm | コンテナを削除。データは消えないです。<br>イメージをリビルドしたり、docker-compose.ymlを変更した場合は一回コンテナを削除することをお勧めします。 |
| docker logs < container name > | コンテナのコンソールを表示<br>`-f`オプションでリアルタイムに表示できる。`Ctrl+C`でキャンセルできる。 |
| docker-compose logs | コンテナのコンソールを表示<br>`-f`オプションでリアルタイムに表示できる。`Ctrl+C`でキャンセルできる。<br>文字化けする可能性があるので上のコマンドのほうがお勧め。 |
| docker attach < container name > | コンテナのコンソールにアタッチできる。<br>デタッチしたい場合は`Ctrl+P`を押した後に`Ctrl+Q`を押す。 |
| docker ps | 稼働しているコンテナ一覧を確認することができる。<br>`-a`オプションですべて表示させることができる。<br>`-q`オプションでイメージIDのみ表示させることができる。 |

## rcon-cliの使い方
rconとは、Minecraftコマンドをリモートで実行するためのプロトコルです。
Dockerfileを書き換えない限り、ポートが剥き出しになることはありません。
```
docker exec -it < container name > rcon-cli <commnad>
```
使用例("say HelloWorld!"を実行)
```
docker exec -it minecraft rcon-cli say HelloWorld! 
```

## Docker imageのビルド方法
### 注意点
`master`ブランチにpushを行うと自動的にビルドしてくれます。

### コマンド
```
docker build --tag minecraft .
docker tag minecraft ghcr.io/ryo-icy/minecraft:latest
```

## docker-compose.ymlの仕様
- コンテナ(マインクラフトサーバ)が異常終了した場合は、自動で起動してくる。
- サーバ起動時に自動で起動してくる。

  ※マインクラフトサーバ上で`/stop`を打ち込んでも自動復旧してしまいます。
  
  ※回避するには`docker-compose.yml`の`restart:`の列を削除してください。
- `./data`ディレクトリにマインクラフトサーバのデータが保存される。

## docker-compose.ymlのパラメータ
| parameter | 説明 | 例 |
| --- | --- | --- |
| service name | サービス名を入力。 | mc |
| container name | コンテナ名を入力。service nameと同じ。 | mc |
| host port | ホストのポートを設定 。| 25565 |
| max memory | メモリの最大容量を入力。 | 4G |
| min memory | メモリの最小容量を入力。 | 2G |
| jar file | jarファイル名を指定。 | spigot-1.17.jar |

## docker-compose.ymlの例
```yml
version: '3.3'
services:
  mc:
    image: "ghcr.io/ryo-icy/minecraft:latest"
    tty: true
    stdin_open: true
    restart: always
    container_name: mc
    ports:
      - 25565:25565
    environment:
      MAX_MEM: 4G
      MIN_MEM: 2G
      JAR_FILE: spigot-1.17.jar
    volumes:
      - ./data:/minecraft
    networks:
      - minecraft-network
networks:
  minecraft-network:
    external: true
```

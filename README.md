# 🦗Repos Hopper
gitのリポジトリを楽に移動するためのツール。

## インストール・更新方法
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/taiga533/repos-hopper/master/install.sh)"
```

## 使用方法
### 1. ツールにgitローカルリポジトリを登録する
```bash
cd [リポジトリへのpath]
rh add
```

### 2. 登録したディレクトリを選択して移動
```bash
rh
```

### 存在しなくなったリポジトリをリポジトリ一覧から削除
```bash
rh clean
```

### 登録されたリポジトリ一覧と各リポジトリの最新コミットを表示
```bash
rh list
```

### help
```bash
rh --help
# もしくは
rh -h
```
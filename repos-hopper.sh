#!/bin/bash

show_help() {
  cat << EOF
使用方法: $(basename "$0") [オプション] [引数]

オプション:
  add <dir>       指定したディレクトリを設定ファイルに追加します。
  uninstall       スクリプトと設定を削除します。
  list            登録されたすべてのリポジトリのgit logを表示します。
  clean           存在しないリポジトリを設定ファイルから削除します。
  --help, -h      このヘルプメッセージを表示します。

何もオプションを指定しなかった場合、fzfを使って登録されたリポジトリから一つを選択してそのディレクトリに移動します。
EOF
}

# 指定されたディレクトリがファイルに存在するかをチェック
contains_dir() {
  local git_dir="$1"
  local file="$2"
  grep -Fq "$git_dir" "$file"
}

# ファイルを更新して新しいディレクトリを追加
update_file() {
  local git_dir="$1"
  local file="$2"
  echo "$git_dir" >> "$file"
}

# ディレクトリがまだファイルに存在しない場合、追加する
add_to_file() {
  local git_dir="$1"
  local file="$2"
  
  if ! contains_dir "$git_dir" "$file"; then
    update_file "$git_dir" "$file"
    echo "$git_dir を $file に追加しました。"
  else
    echo "$git_dir はすでに $file に存在します。"
  fi
}

# ディレクトリがgitリポジトリであるかを検証
is_git_repo() {
  local target_dir="$1"
  git -C "$target_dir" rev-parse --is-inside-work-tree &> /dev/null
}

# ディレクトリがgitリポジトリであれば、ファイルに追加
check_and_add_repo() {
  local target_dir="$1"
  local file="$2"

  if is_git_repo "$target_dir"; then
    local git_dir
    git_dir=$(git -C "$target_dir" rev-parse --show-toplevel)
    add_to_file "$git_dir" "$file"
  else
    echo "これはgitリポジトリではありません。何も行いません。"
  fi
}

# fzfを使用してリポジトリを選び、そのディレクトリに移動
goto_selected_repo() {
  local file="$1"
  local selected_repo
  selected_repo=$(cat "$file" | fzf)
  [ -n "$selected_repo" ] && cd "$selected_repo" || echo "エラー: ディレクトリが選択されませんでした。"
}

# スクリプトをアンインストール
uninstall_script() {
  local script_path="$1"
  local file="$2"
  rm -f "$script_path"
  rm -f "$file"
  echo "スクリプトと設定を削除しました。"
}

# 登録されたすべてのリポジトリのgit logを表示
show_all_repos() {
  local file="$1"
  local git_dir
  while read -r git_dir; do
    echo "[$(basename "$git_dir")]"
    git -C "$git_dir" log -n 1 --decorate --color=always | cat
  done < "$file"
}

# 存在しないリポジトリを設定ファイルから削除
remove_nonexistent_repos() {
  local file="$1"
  local git_dir
  local existing_repos=()
  
  while read -r git_dir; do
    if [ -d "$git_dir" ]; then
      existing_repos+=("$git_dir")
    else
      echo "$git_dir は存在しないため、$file から削除します。"
    fi
  done < "$file"
  
  # 配列をファイルに書き込む
  printf "%s\n" "${existing_repos[@]}" >| "$file"
}

# メイン処理
file="$HOME/.config/repos-hopper/git_repos.txt"
# ディレクトリがなかったら作成
[ ! -d "$(dirname "$file")" ] && mkdir -p "$(dirname "$file")"
# ファイルがなかったら作成
[ ! -f "$file" ] && touch "$file"

case "$1" in
  add)
    check_and_add_repo "$2" "$file"
    ;;
  uninstall)
    uninstall_script "$0" "$file"
    ;;
  list)
    show_all_repos "$file"
    ;;
  clean)
    remove_nonexistent_repos "$file"
    ;;
  --help|-h)
    show_help
    ;;
  *)
    goto_selected_repo "$file"
    ;;
esac
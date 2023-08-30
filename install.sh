## repos-hopper.shのインストールスクリプト
echo "repos-hopper.shをインストールします。"
echo "ユーザーのホームディレクトリにrepos-hopper.shを配置し、実行権限を付与します。"
curl -sSfL https://raw.githubusercontent.com/taiga533/repos-hopper/master/repos-hopper.sh >| ~/repos-hopper.sh
chmod +x ~/repos-hopper.sh
echo "インストールが完了しました。"

cat << EOF
zshまたはbashの設定ファイル(~/.zshrc, ~/.bashrc)に以下の行を追加してください。
alias rh="source ~/repos-hopper.sh"
EOF
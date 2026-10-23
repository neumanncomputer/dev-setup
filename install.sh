#!/usr/bin/env bash
# ~/.zshrc と ~/.bashrc にこのリポジトリの設定を読み込む行を追記し、ツールをインストールする
# Mac と Linux の両方で動く（何度実行しても同じ結果になる）
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ファイルに行がなければ末尾に追記する（ファイルがなければ作る）
append_line() {
  local file="$HOME/$1"
  local line="$2"

  if [[ -f "$file" ]] && grep -qxF "$line" "$file"; then
    echo "追記済み: ~/$1"
    return
  fi

  # 既存の内容があれば、空行を挟んでから追記する
  if [[ -s "$file" ]]; then
    # 末尾が改行で終わっていなければ、先に改行する
    [[ -n "$(tail -c 1 "$file")" ]] && echo >>"$file"
    echo >>"$file"
  fi
  {
    echo "# dev-config の設定を読み込む"
    echo "$line"
  } >>"$file"
  echo "追記: ~/$1"
}

echo "===== シェルの設定 ====="
append_line .zshrc "[[ -r \"$REPO_DIR/.zshrc\" ]] && source \"$REPO_DIR/.zshrc\""
append_line .bashrc "[[ -r \"$REPO_DIR/.bashrc\" ]] && source \"$REPO_DIR/.bashrc\""
# ログイン時の bash は ~/.bash_profile しか読まないため、~/.bashrc を読み込ませる
# Linux で ~/.bash_profile がない場合は、~/.profile が ~/.bashrc を読むので作らない
if [[ "$OSTYPE" == darwin* || -f "$HOME/.bash_profile" ]]; then
  append_line .bash_profile "[[ -r ~/.bashrc ]] && source ~/.bashrc"
fi

echo "===== mise ====="
if ! command -v mise >/dev/null && [[ ! -x "$HOME/.local/bin/mise" ]]; then
  curl -fsSL https://mise.run | sh
fi
MISE="$(command -v mise || echo "$HOME/.local/bin/mise")"
# ホームディレクトリで実行し、リポジトリのグローバル設定のツールだけをインストールする
(cd "$HOME" && MISE_GLOBAL_CONFIG_FILE="$REPO_DIR/.config/mise/config.toml" "$MISE" install)

echo
echo "完了。ログインシェルを変えるには: chsh -s \"\$(command -v zsh)\"（bash なら zsh を bash に）"

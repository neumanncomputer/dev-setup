# ~/.bashrc から読み込まれる bash の設定
# このマシンだけの設定は ~/.bashrc の読み込み行より下に書く

# 二重読み込みを防ぐ（~/.bash_profile や ~/.profile から読まれることがあるため）
[[ -n "${DEV_CONFIG_BASHRC_LOADED:-}" ]] && return
DEV_CONFIG_BASHRC_LOADED=1

# ===== 共通の設定 =====
# このファイルの場所からリポジトリの場所を求める
DEV_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DEV_CONFIG_DIR
source "$DEV_CONFIG_DIR/.config/shell/common.sh"

# ランタイムバージョン管理ツール（スクリプトから使うこともあるため対話シェル以外でも読み込む）
if command -v mise >/dev/null; then
  eval "$(mise activate bash)"
fi

# ここから下は対話シェルのみ
[[ $- == *i* ]] || return 0

# ===== 履歴 =====
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoredups
shopt -s histappend

# ===== 補完 =====
for f in /usr/share/bash-completion/bash_completion /opt/homebrew/etc/profile.d/bash_completion.sh; do
  if [[ -r "$f" ]]; then
    source "$f"
    break
  fi
done

# ===== ツールの初期化 =====
# プロンプト（シェルの表示部分）カスタマイズツール
if command -v starship >/dev/null; then
  eval "$(starship init bash)"
fi

# コマンドヒストリー管理ツール
if command -v atuin >/dev/null; then
  eval "$(atuin init bash)"
fi

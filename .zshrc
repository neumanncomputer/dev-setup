# ~/.zshrc から読み込まれる zsh の設定
# このマシンだけの設定は ~/.zshrc の読み込み行より下に書く

# ===== 共通の設定 =====
# このファイルの場所からリポジトリの場所を求める
export DEV_CONFIG_DIR="${${(%):-%x}:A:h}"
source "$DEV_CONFIG_DIR/.config/shell/common.sh"

# ===== 履歴 =====
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt share_history hist_ignore_dups

# ===== 補完 =====
autoload -Uz compinit
compinit

# ===== ツールの初期化 =====
# ランタイムバージョン管理ツール
if command -v mise >/dev/null; then
  eval "$(mise activate zsh)"
fi

# プロンプト（シェルの表示部分）カスタマイズツール
if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
fi

# コマンドヒストリー管理ツール
if command -v atuin >/dev/null; then
  eval "$(atuin init zsh)"
fi

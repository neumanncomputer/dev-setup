# zsh と bash の両方から読み込む共通の設定
# 両方で動く書き方だけを使う（DEV_CONFIG_DIR は読み込み元で設定済み）

# mise などのインストール先
export PATH="$HOME/.local/bin:$PATH"

# Homebrew（Mac のみ）
if [[ "$OSTYPE" == darwin* ]] && [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 設定ファイルはリンクせず、リポジトリのファイルを直接読ませる
export MISE_GLOBAL_CONFIG_FILE="$DEV_CONFIG_DIR/.config/mise/config.toml"
export STARSHIP_CONFIG="$DEV_CONFIG_DIR/.config/starship.toml"

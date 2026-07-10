#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_BIN="$SOURCE_DIR/boil"

if [ ! -f "$SOURCE_BIN" ]; then
  printf '找不到脚本文件: %s\n' "$SOURCE_BIN" >&2
  exit 1
fi

if ! bash -n "$SOURCE_BIN"; then
  printf '脚本语法校验失败: %s\n' "$SOURCE_BIN" >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  INSTALL_DIR="/usr/local/bin"
  CONFIG_DIR="/etc/boil"
else
  INSTALL_DIR="${HOME:-/tmp}/.local/bin"
  CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME:-/tmp}/.config}/boil"
fi

mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"
install -m 0755 "$SOURCE_BIN" "$INSTALL_DIR/boil"
chmod 700 "$CONFIG_DIR" 2>/dev/null || true

printf '已安装命令: %s/boil\n' "$INSTALL_DIR"
printf '配置目录: %s\n' "$CONFIG_DIR"

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    printf '\n注意: %s 不在 PATH 中。\n' "$INSTALL_DIR"
    printf '可以临时运行: export PATH="%s:%cPATH"\n' "$INSTALL_DIR" '$'
    ;;
esac

printf '\n现在运行 boil 即可打开菜单。\n'

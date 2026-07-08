#!/usr/bin/env bash
set -euo pipefail

RAW_BASE="${BOIL_INSTALL_RAW_BASE:-https://raw.githubusercontent.com/chnnic/Boil-Change-IP/main}"
SOURCE_URL="$RAW_BASE/boil"

if [ "$(id -u)" -eq 0 ]; then
  INSTALL_DIR="/usr/local/bin"
  CONFIG_DIR="/etc/boil"
else
  INSTALL_DIR="${HOME:-/tmp}/.local/bin"
  CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME:-/tmp}/.config}/boil"
fi

download() {
  local url="$1"
  local output="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$output"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$output" "$url"
  else
    printf '缺少下载工具: curl 或 wget\n' >&2
    printf 'Debian/Ubuntu 可先运行: apt update && apt install -y curl python3 ca-certificates\n' >&2
    exit 1
  fi
}

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

download "$SOURCE_URL" "$tmp_file"

mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"
install -m 0755 "$tmp_file" "$INSTALL_DIR/boil"
chmod 700 "$CONFIG_DIR" 2>/dev/null || true

printf '已安装命令: %s/boil\n' "$INSTALL_DIR"
printf '配置目录: %s\n' "$CONFIG_DIR"

if ! command -v curl >/dev/null 2>&1 || ! command -v python3 >/dev/null 2>&1; then
  printf '\n注意: boil 运行需要 curl 和 python3。\n'
  printf 'Debian/Ubuntu 安装依赖: apt update && apt install -y curl python3 ca-certificates\n'
  printf 'CentOS/RHEL 安装依赖: yum install -y curl python3 ca-certificates\n'
fi

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    printf '\n注意: %s 不在 PATH 中。\n' "$INSTALL_DIR"
    printf '可以临时运行: export PATH="%s:$PATH"\n' "$INSTALL_DIR"
    ;;
esac

printf '\n现在运行 boil 即可打开菜单。\n'

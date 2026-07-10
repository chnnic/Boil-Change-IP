#!/usr/bin/env bash
set -euo pipefail

RAW_BASE="${BOIL_INSTALL_RAW_BASE:-https://raw.githubusercontent.com/chnnic/Boil-Change-IP/main}"
SOURCE_URL="$RAW_BASE/boil"
CHECKSUM_URL="$RAW_BASE/boil.sha256"

case "$SOURCE_URL" in
  http://*|https://*)
    cache="$(date +%s)"
    SOURCE_URL="$SOURCE_URL?cache=$cache"
    CHECKSUM_URL="$CHECKSUM_URL?cache=$cache"
    ;;
esac

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

sha256_file() {
  local file="$1"

  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$file" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$file" | awk '{print $1}'
  elif command -v openssl >/dev/null 2>&1; then
    openssl dgst -sha256 "$file" | awk '{print $NF}'
  else
    printf '缺少 SHA256 校验工具: sha256sum、shasum 或 openssl\n' >&2
    return 1
  fi
}

temp_base="${TMPDIR:-/tmp}"
if [ ! -d "$temp_base" ] || [ ! -w "$temp_base" ]; then
  temp_base="${XDG_CACHE_HOME:-${HOME:-/tmp}/.cache}/boil-installer"
  mkdir -p "$temp_base"
  chmod 700 "$temp_base" 2>/dev/null || true
fi

tmp_file="$(mktemp "$temp_base/boil.XXXXXX")"
checksum_file="$(mktemp "$temp_base/boil-sha256.XXXXXX")"
trap 'rm -f "$tmp_file" "$checksum_file"' EXIT

download "$SOURCE_URL" "$tmp_file"
download "$CHECKSUM_URL" "$checksum_file"

expected="$(awk 'NR == 1 {print $1}' "$checksum_file")"
if ! [[ "$expected" =~ ^[0-9a-fA-F]{64}$ ]]; then
  printf '安装失败: 校验文件格式无效。\n' >&2
  exit 1
fi
actual="$(sha256_file "$tmp_file")"
if [ "${actual,,}" != "${expected,,}" ]; then
  printf '安装失败: SHA256 校验不匹配。\n' >&2
  printf '期望: %s\n实际: %s\n' "$expected" "$actual" >&2
  exit 1
fi

if ! bash -n "$tmp_file"; then
  printf '安装失败: 下载到的脚本语法校验未通过。\n' >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR" "$CONFIG_DIR"
install -m 0755 "$tmp_file" "$INSTALL_DIR/boil"
chmod 700 "$CONFIG_DIR" 2>/dev/null || true

printf '已安装命令: %s/boil\n' "$INSTALL_DIR"
printf '配置目录: %s\n' "$CONFIG_DIR"
printf 'SHA256 校验通过: %s\n' "$actual"

if ! command -v curl >/dev/null 2>&1 || ! command -v python3 >/dev/null 2>&1; then
  printf '\n注意: boil 运行需要 curl 和 python3。\n'
  printf 'Debian/Ubuntu 安装依赖: apt update && apt install -y curl python3 ca-certificates\n'
  printf 'CentOS/RHEL 安装依赖: yum install -y curl python3 ca-certificates\n'
fi

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    printf '\n注意: %s 不在 PATH 中。\n' "$INSTALL_DIR"
    printf '可以临时运行: export PATH="%s:%cPATH"\n' "$INSTALL_DIR" '$'
    ;;
esac

printf '\n现在运行 boil 即可打开菜单。\n'

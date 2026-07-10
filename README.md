# Boil Change IP

Boil 家宽 IP API 菜单工具。安装后直接输入 `boil` 打开菜单，不需要反复记忆和输入 API 命令。

当前版本：`V1.0.5`

API 文档来源：<https://cloud.boil.network/tutorial.php#api>

## 功能

- 查询当前 Boil IP
- 查询 IP 质量，不使用 ping0.cc 数据
- 调用 Boil API 更换 IP
- 更换 IP 后显示 API 剩余次数
- 显示下次可更换 IP 的时间
- 本地保存 API Token
- 安装为系统命令 `boil`
- 从 GitHub 拉取更新
- 集成 SSH-Hardening 的 DDNS 模块
- 菜单式操作，适合新手使用

## 安装

### 方式一：不安装 git，直接在线安装

大多数 VPS 可以直接运行：

```bash
curl -fsSL https://raw.githubusercontent.com/chnnic/Boil-Change-IP/main/install-online.sh | bash
```

如果提示 `curl: command not found`，先安装依赖：

```bash
apt update && apt install -y curl python3 ca-certificates
```

CentOS/RHEL 系统可以使用：

```bash
yum install -y curl python3 ca-certificates
```

安装完成后运行：

```bash
boil
```

在线安装器会下载 `boil.sha256`，只有 SHA256 和 Bash 语法校验都通过才会安装。

### 升级旧版

如果你的菜单里还没有：

```text
9) 更新脚本（从 GitHub 拉取）
```

说明本机还是旧版脚本。旧版没有菜单更新入口，需要先手动更新一次：

```bash
curl -fsSL https://raw.githubusercontent.com/chnnic/Boil-Change-IP/main/install-online.sh | bash
```

更新完成后重新运行：

```bash
boil
```

以后可以直接在菜单里选择 `9) 更新脚本（从 GitHub 拉取）`，或者运行：

```bash
boil update
```

查看当前版本：

```bash
boil version
```

### 方式二：使用 git 下载并安装

```bash
git clone https://github.com/chnnic/Boil-Change-IP.git
cd Boil-Change-IP
sudo bash install.sh
```

安装完成后运行：

```bash
boil
```

如果提示 `git: command not found`，说明服务器没有安装 Git。可以先安装 Git：

```bash
apt update && apt install -y git curl python3 ca-certificates
```

或者直接使用上面的“方式一”在线安装。

### 方式三：不安装，直接运行

```bash
git clone https://github.com/chnnic/Boil-Change-IP.git
cd Boil-Change-IP
chmod +x boil
./boil
```

## 使用方法

运行：

```bash
boil
```

进入菜单后按数字选择：

```text
1) 查询当前 IP
2) IP 质量查询
3) 更换 IP
4) 更换 IP 并等待新 IP
5) 查看 API 剩余次数缓存
6) 设置/更新 API Token
7) 查看 Token 保存位置
8) 删除已保存 Token
9) 更新脚本（从 GitHub 拉取）
10) DDNS 管理（SSH-Hardening 模块）
0) 退出
```

首次使用请先选择 `6) 设置/更新 API Token`。

输入 API Token 时屏幕不会显示字符。直接粘贴并按 Enter 即可保存，脚本随后会显示脱敏后的 Token。

## IP 质量查询

菜单选择 `2) IP 质量查询` 后，可以选择：

```text
1) 查询 Boil 当前 IP 质量（需要 API Token）
2) 查询本机公网出口 IP 质量
3) 手动输入 IP 查询质量
0) 返回主菜单
```

IP 质量查询不会使用 ping0.cc 数据。

当前使用的数据：

- `ipapi.is`（HTTPS）：国家、地区、ASN、ISP、网络类型、代理、VPN、Tor、滥用和机房标记
- DNSBL 本地查询：Spamhaus ZEN、Spamcop、SORBS、Barracuda

基础数据查询失败时会显示“无法判断”，不会把未知状态判为“较干净”。IP 质量结果仍仅供参考，不同平台的风控规则不同。

## 更新脚本

`V1.0.3` 起，菜单内置更新入口。进入菜单后选择：

```text
9) 更新脚本（从 GitHub 拉取）
```

脚本会同时下载最新版和 `boil.sha256`。只有 SHA256、Bash 语法和版本号检查都通过，且不是降级版本时，才会覆盖本地 `boil` 命令。

也可以不进菜单，直接运行：

```bash
boil update
```

如果执行 `boil update` 提示命令不存在，或者菜单里没有第 `9` 项，说明本机还是旧版，请使用上面的“升级旧版”命令先手动更新一次。

查看当前版本：

```bash
boil version
```

## DDNS 管理

菜单选择：

```text
10) DDNS 管理（SSH-Hardening 模块）
```

这个入口会复用 `SSH-Hardening` 的 DDNS 模块，支持 Cloudflare 和华为云 DNS。

调用逻辑：

1. DDNS 管理必须使用 root 权限运行。
2. 如果系统已经安装 `SSH-Hardening`，会优先调用 root 拥有且不可被组/其他用户写入的固定入口：
   - `/usr/local/bin/vps-tools --ddns-menu`
   - `/usr/local/bin/v --ddns-menu`
   - `/usr/local/bin/V --ddns-menu`
3. 如果系统没有安装 `SSH-Hardening`，Boil 会临时下载固定版本的 SSH-Hardening 管理器，并用内置 SHA256 校验。
4. 管理器退出后临时文件立即删除；系统只保留 `/root/ddns.sh`、凭据、配置、日志和 cron 等 DDNS 运行文件，不创建 `vps-tools`、`v`、`V` 主命令。

当前固定管理器版本为 SSH-Hardening `V3.9.38`（commit `9a9eb16`），SHA256 为 `08e09be4ef88569ea2d25ff17a9479661a8dfafd0a2c2521f4ce57665fdcdd54`。

也可以直接运行：

```bash
boil ddns
```

仅安装并配置 DDNS 运行模块：

```bash
boil ddns-install
```

立即执行一次 DDNS 更新：

```bash
boil ddns-run
```

如果 V1.0.4 曾创建过旧 helper，可以在升级后删除；V1.0.5 不再执行它：

```bash
rm -f /usr/local/lib/boil/ssh-hardening-ddns.sh
```

DDNS 模块会使用 `SSH-Hardening` 的原有文件路径：

- DDNS 执行脚本：`/root/ddns.sh`
- Cloudflare Token：`/root/.cf_token`
- 华为云 AK/SK：`/root/.hw_dns_aksk`
- DDNS 配置：`/root/.cf_zone`
- DDNS 日志：`/var/log/ddns.log`

DDNS 模块来源：<https://github.com/chnnic/SSH-Hardening>

## 获取 API Token

1. 打开 Boil IP 管理面板：<https://ippanel.boil.network/>
2. 登录并取得 IP 后，点击“获取 API”。
3. 复制生成的 API Token。
4. 运行 `boil`，在菜单中选择 `6) 设置/更新 API Token`，粘贴 Token。

## API 剩余次数说明

Boil 的 `getIP` 接口只返回当前 IP。

Boil 的 `changeIP` 接口成功后会返回：

```json
{
  "ok": true,
  "message": "正在执行更换IP",
  "uses_left": 2,
  "next_allowed_at": 1782732942
}
```

所以本工具会在成功更换 IP 后，把 `uses_left` 缓存在本地。没有成功换过 IP 前，菜单会显示“API 剩余次数：未知”。

## 文件位置

使用 `sudo bash install.sh` 安装时：

- 命令：`/usr/local/bin/boil`
- Token：`/etc/boil/token`
- 状态缓存：`/etc/boil/state.json`

普通用户安装时：

- 命令：`~/.local/bin/boil`
- Token：`~/.config/boil/token`
- 状态缓存：`~/.local/state/boil/state.json`

## API 接口

查询当前 IP：

```bash
curl -X POST -H "Authorization: Bearer <token>" https://ippanel.boil.network/api/v1/getIP
```

更换 IP：

```bash
curl -X POST -H "Authorization: Bearer <token>" https://ippanel.boil.network/api/v1/changeIP/
```

## 卸载

如果是 `sudo bash install.sh` 安装：

```bash
sudo rm -f /usr/local/bin/boil
sudo rm -rf /etc/boil
```

如果是普通用户安装：

```bash
rm -f ~/.local/bin/boil
rm -rf ~/.config/boil ~/.local/state/boil
```

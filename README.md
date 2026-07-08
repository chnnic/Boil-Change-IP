# Boil Change IP

Boil 家宽 IP API 菜单工具。安装后直接输入 `boil` 打开菜单，不需要反复记忆和输入 API 命令。

当前版本：`V1.0.3`

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
0) 退出
```

首次使用请先选择 `6) 设置/更新 API Token`。

输入 API Token 时会在屏幕上显示出来，粘贴后按 Enter 即可保存。

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

- `ip-api.com`：国家、地区、ASN、ISP、组织、是否移动网络、是否代理/VPN/Tor、是否 Hosting/机房
- DNSBL 本地查询：Spamhaus ZEN、Spamcop、SORBS、Barracuda

说明：IP 质量结果仅供参考。不同平台的风控规则不同，检测结果不能保证账号、支付、注册、直播或电商场景一定可用。

## 更新脚本

进入菜单后选择：

```text
9) 更新脚本（从 GitHub 拉取）
```

脚本会从 GitHub 下载最新版，先做语法校验，再覆盖本地 `boil` 命令。

也可以直接运行：

```bash
boil update
```

查看当前版本：

```bash
boil version
```

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

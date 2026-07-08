# Boil Change IP

Boil 家宽 IP API 菜单工具。安装后直接输入 `boil` 打开菜单，不需要反复记忆和输入 API 命令。

API 文档来源：<https://cloud.boil.network/tutorial.php#api>

## 功能

- 查询当前 Boil IP
- 调用 Boil API 更换 IP
- 更换 IP 后显示 API 剩余次数
- 显示下次可更换 IP 的时间
- 本地保存 API Token
- 安装为系统命令 `boil`
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
2) 更换 IP
3) 更换 IP 并等待新 IP
4) 查看 API 剩余次数缓存
5) 设置/更新 API Token
6) 查看 Token 保存位置
7) 删除已保存 Token
0) 退出
```

首次使用请先选择 `5) 设置/更新 API Token`。

## 获取 API Token

1. 打开 Boil IP 管理面板：<https://ippanel.boil.network/>
2. 登录并取得 IP 后，点击“获取 API”。
3. 复制生成的 API Token。
4. 运行 `boil`，在菜单中选择 `5) 设置/更新 API Token`，粘贴 Token。

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

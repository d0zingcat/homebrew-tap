# D0zingcat Tap

## How do I install these formulae?

`brew install d0zingcat/tap/<formula>`

Or `brew tap d0zingcat/tap` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "d0zingcat/tap"
cask "loon4mac"
```

## Available Casks

| Cask | Description | Project | Homepage |
|------|-------------|---------|----------|
| antigravity-cli | Google Antigravity CLI (`antigravity-cli`) | [Antigravity CLI](https://antigravity.google/cli) | [antigravity.google/cli](https://antigravity.google/cli) |
| doubao-ime | Doubao Input Method - AI input method | [Doubao Input Method](https://shurufa.doubao.com/pc) | [shurufa.doubao.com](https://shurufa.doubao.com/pc) |
| loon4mac | Loon for macOS - Network debugging tool | [Loon4Mac](https://github.com/Loon0x00/Loon4Mac) | [nsloon.com](https://nsloon.com) |
| push-to-talk | PushToTalk - Push-to-talk helper for Doubao IME | [push-to-talk](https://github.com/d0zingcat/push-to-talk) | [github.com/d0zingcat/push-to-talk](https://github.com/d0zingcat/push-to-talk) |
| todesk | ToDesk - Remote control software | [ToDesk](https://www.todesk.com/) | [todesk.com](https://www.todesk.com/) |
| typeswitch | TypeSwitch - Input method switcher | [TypeSwitch](https://github.com/ygsgdbd/TypeSwitch) | [github.com/ygsgdbd/TypeSwitch](https://github.com/ygsgdbd/TypeSwitch) |
| wakeup-macos | WakeupMenu - Remote wake utility | [wakeup-macos](https://github.com/d0zingcat/wakeup-macos) | [github.com/d0zingcat/wakeup-macos](https://github.com/d0zingcat/wakeup-macos) |

## ToDesk 安装说明

ToDesk 官方 CDN 带有 CAPTCHA，`brew install` 可能下载到约 2KB 的 HTML 页面并报 checksum 错误（例如 `87fa9661...`）。**不要**把 cask 里的 sha256 改成这个值。

### 推荐：浏览器下载 + 安装脚本

```sh
# 1. 用浏览器从官网下载 pkg
#    https://www.todesk.com/download.html

# 2. 运行 tap 安装脚本（会校验 SHA-256、清理错误缓存、注入 brew 缓存并安装）
bash "$(brew --repo d0zingcat/tap)/scripts/todesk-install-from-download.sh" ~/Downloads/ToDesk_4.9.6.0.pkg
```

### 手动注入缓存

```sh
# 确认 pkg 大于 1MB 且 SHA-256 正确
shasum -a 256 ~/Downloads/ToDesk_4.9.6.0.pkg

# 删除错误的 CAPTCHA 缓存（若存在）
rm -f ~/Library/Caches/Homebrew/downloads/*--ToDesk_4.9.6.0.pkg

# 复制到 brew 缓存
cp ~/Downloads/ToDesk_4.9.6.0.pkg \
  ~/Library/Caches/Homebrew/downloads/ddbcbcd0a7499ac21a8a00c4dfc11751ec4c0c506dc1ad6e6455a5c8faed8e05--ToDesk_4.9.6.0.pkg

brew install --cask d0zingcat/tap/todesk
```

### 维护者：发布 GitHub Release 镜像（可选）

浏览器下载 pkg 后，可上传到 GitHub Release，供所有用户绕过 CAPTCHA：

```sh
bash "$(brew --repo d0zingcat/tap)/scripts/todesk-publish-release.sh" ~/Downloads/ToDesk_4.9.6.0.pkg
```

然后将 `Casks/todesk.rb` 的 `url` 改为脚本输出的 GitHub Release 地址。

版本号与 `sha256` 以 `Casks/todesk.rb` 为准；升级 cask 后请同步更新脚本与 README。

卸载请使用 `brew uninstall --cask --zap todesk`，不要仅将 app 拖入废纸篓。

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

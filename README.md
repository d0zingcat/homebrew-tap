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

ToDesk 官方下载链带有 CAPTCHA 验证，`brew install` 有时会因 checksum 校验失败而中断。可改用浏览器手动下载，再注入 Homebrew 缓存后安装：

```sh
# 1. 从官网下载页获取 pkg（当前版本见 Casks/todesk.rb）
#    https://www.todesk.com/download.html

# 2. 确认 SHA-256 与 cask 中 sha256 字段一致
shasum -a 256 ~/Downloads/ToDesk_4.9.6.0.pkg

# 3. 放入 Homebrew 下载缓存（格式：<sha256>--<原始文件名>）
cp ~/Downloads/ToDesk_4.9.6.0.pkg \
  ~/Library/Caches/Homebrew/downloads/25c8784ba5b6aa5dd13b837f354172e1751462de8988261ba04bbaa3d4c34538--ToDesk_4.9.6.0.pkg

# 4. 重新安装（跳过下载，使用缓存）
brew install --cask d0zingcat/tap/todesk
```

版本号与 `sha256` 以 `Casks/todesk.rb` 为准；升级 cask 后请同步更新上述命令中的文件名与缓存路径。

卸载请使用 `brew uninstall --cask --zap todesk`，不要仅将 app 拖入废纸篓。安装完成后运行 `brew info --cask todesk` 也可查看完整说明。

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

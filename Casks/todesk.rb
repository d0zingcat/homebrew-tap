cask "todesk" do
  version "4.9.7.3"
  sha256 "2c4356dcbec5a79a847268a1e329010717047adcaeeba186385952a2c5e8b69c"

  url "https://update.todesk.com/macos/ToDesk_#{version}.pkg"
  name "ToDesk"
  desc "Remote control software"
  homepage "https://www.todesk.com/"

  livecheck do
    url "https://www.todesk.com/download.html"
    regex(/macos\\u002FToDesk_(\d+(?:\.\d+)*)\.pkg/i)
  end

  auto_updates false
  depends_on :macos

  pkg "ToDesk_#{version}.pkg"

  uninstall launchctl: [
              "com.youqu.todesk.client.startup",
              "com.youqu.todesk.desktop",
              "com.youqu.todesk.service",
              "com.youqu.todesk.startup",
            ],
            quit:      "com.youqu.todesk.mac",
            pkgutil:   "com.youqu.todesk.mac",
            delete:    [
              "/Applications/ToDesk.app",
              "/Library/Audio/Plug-Ins/HAL/ToDeskOutputDriver.driver",
              "/Library/LaunchAgents/com.youqu.todesk.client.startup.plist",
              "/Library/LaunchAgents/com.youqu.todesk.desktop.plist",
              "/Library/LaunchAgents/com.youqu.todesk.startup.plist",
              "/Library/LaunchDaemons/com.youqu.todesk.service.plist",
              "/Library/ToDesk",
            ]

  zap trash: [
    "~/Library/Application Scripts/com.youqu.todesk.mac.LaunchHelper",
    "~/Library/Application Support/ToDesk",
    "~/Library/Caches/com.youqu.todesk.mac",
    "~/Library/Containers/com.youqu.todesk.mac.LaunchHelper",
    "~/Library/Group Containers/group.youqu.todesk",
    "~/Library/HTTPStorages/com.youqu.todesk.mac",
    "~/Library/LaunchAgents/com.youqu.todesk.client.startup.plist",
    "~/Library/LaunchAgents/com.youqu.todesk.startup.plist",
    "~/Library/Logs/ToDesk",
    "~/Library/Preferences/com.youqu.todesk.mac.plist",
    "~/Library/Saved Application State/com.youqu.todesk.mac.savedState",
    "~/Library/ToDesk",
  ]

  caveats do
    <<~EOS
      ToDesk 通过 .pkg 安装，会在系统中注册后台服务与 Core Audio 驱动
      （/Library/Audio/Plug-Ins/HAL/ToDeskOutputDriver.driver）。

      请勿仅将 ToDesk.app 拖入废纸篓；请使用以下命令完整卸载：

        brew uninstall --cask --zap todesk

      卸载后若音频相关进程仍残留，建议重启 Mac。

      若 brew install 因下载校验失败，请先用浏览器下载，再运行 tap 中的安装脚本：

        curl -fsSL https://raw.githubusercontent.com/d0zingcat/homebrew-tap/HEAD/scripts/todesk-install-from-download.sh | bash -s -- ~/Downloads/ToDesk_#{version}.pkg

      或手动注入 Homebrew 缓存后安装：

        1. 打开 https://www.todesk.com/download.html ，下载 ToDesk_#{version}.pkg
        2. 确认文件大于 1MB，且校验值正确：
             shasum -a 256 ~/Downloads/ToDesk_#{version}.pkg
        3. 删除可能存在的错误缓存：
             rm -f ~/Library/Caches/Homebrew/downloads/*--ToDesk_#{version}.pkg
        4. 复制正确 pkg 到 Homebrew 下载缓存（键为下载 URL 的 SHA-256）：
             cp ~/Downloads/ToDesk_#{version}.pkg \\
               ~/Library/Caches/Homebrew/downloads/037da7e74b772688d994aca983affe2477f158b55635f9728478ee577c46361e--ToDesk_#{version}.pkg
        5. 重新安装：
             brew install --cask #{token}
    EOS
  end
end

cask "todesk" do
  version "4.9.6.0"
  sha256 "25c8784ba5b6aa5dd13b837f354172e1751462de8988261ba04bbaa3d4c34538"

  url "https://dl.todesk.com/macos/ToDesk_#{version}.pkg",
      user_agent: :fake,
      referer:    "https://www.todesk.com/"
  name "ToDesk"
  desc "Remote control software"
  homepage "https://www.todesk.com/"

  livecheck do
    url "https://www.todesk.com/download.html"
    regex(/macos\\u002FToDesk_(\d+(?:\.\d+)*)\.pkg/i)
  end

  auto_updates true

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

      若 brew install 因下载校验失败（官方 CDN 可能返回 CAPTCHA 页面），
      可用浏览器手动下载后注入 Homebrew 缓存，再重新安装：

        1. 打开 https://www.todesk.com/download.html ，下载 ToDesk_#{version}.pkg
        2. 确认校验值与 cask 一致（可运行 brew info --cask #{token} 查看 sha256）：
             shasum -a 256 ~/Downloads/ToDesk_#{version}.pkg
        3. 复制到 Homebrew 下载缓存（文件名格式为 sha256--原始文件名）：
             cp ~/Downloads/ToDesk_#{version}.pkg \\
               ~/Library/Caches/Homebrew/downloads/25c8784ba5b6aa5dd13b837f354172e1751462de8988261ba04bbaa3d4c34538--ToDesk_#{version}.pkg
        4. 重新安装（将跳过下载，直接使用缓存文件）：
             brew install --cask #{token}
    EOS
  end
end

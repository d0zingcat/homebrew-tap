cask "doubao-ime" do
  version "0.9.0"
  sha256 "b3db587a25deca06964c2d88961ccbb7824f14e58b5347bad5893f7fd9b1a421"

  url "https://lf-wave.doubaocdn.com/obj/doubao-ime/app/mac/DoubaoImeInstaller_v#{version}.zip",
      verified: "lf-wave.doubaocdn.com/obj/doubao-ime/"
  name "Doubao Input Method"
  name "豆包输入法"
  desc "AI input method"
  homepage "https://shurufa.doubao.com/pc"

  livecheck do
    url "https://shurufa.doubao.com/api/v1/app/download_url?platform=macos"
    strategy :json do |json|
      json.dig("data", "version_name")&.delete_prefix("V")
    end
  end

  depends_on macos: :catalina
  container nested: "DoubaoImeInstaller_v#{version}.app/Contents/Resources/DoubaoIme.zip"

  input_method "DoubaoIme.app", target: "/Library/Input Methods/DoubaoIme.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args:         ["-d", "-r", "com.apple.quarantine", "/Library/Input Methods/DoubaoIme.app"],
                   must_succeed: false,
                   sudo:         true
    system_command "/usr/bin/killall",
                   args:         ["SystemUIServer"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/DoubaoIme",
    "~/Library/Caches/com.bytedance.inputmethod.doubaoime",
    "~/Library/Caches/com.bytedance.inputmethod.doubaoime.settings",
    "~/Library/HTTPStorages/com.bytedance.inputmethod.doubaoime",
    "~/Library/HTTPStorages/com.bytedance.inputmethod.doubaoime.settings",
    "~/Library/Preferences/com.bytedance.inputmethod.doubaoime.plist",
    "~/Library/Preferences/com.bytedance.inputmethod.doubaoime.settings.plist",
  ]

  caveats do
    <<~EOS
      豆包输入法已安装到 /Library/Input Methods/DoubaoIme.app。

      安装后若系统设置里还看不到，请先注销并重新登录一次，再打开
      系统设置 → 键盘 → 编辑输入法，用「+」添加「豆包输入法」。
    EOS
  end
end

cask "doubao-ime" do
  version "0.9.3,90302"
  sha256 "ab9eee36f43f8cdc459d0971c0ea1ca7d220f24e839580990f0aade40b1bd771"

  url "https://lf-wave.doubaocdn.com/obj/doubao-ime/app/macos/DoubaoImeInstaller_v#{version.csv.second}.zip",
      verified: "lf-wave.doubaocdn.com/obj/doubao-ime/"
  name "Doubao Input Method"
  name "豆包输入法"
  desc "AI input method"
  homepage "https://shurufa.doubao.com/pc"

  livecheck do
    url "https://shurufa.doubao.com/api/v1/app/download_url?platform=macos"
    strategy :json do |json|
      version_name = json.dig("data", "version_name")&.delete_prefix("V")
      download_url = json.dig("data", "url")
      build_match = download_url&.match(/DoubaoImeInstaller_v(\d+)\.zip/i)
      build = build_match&.captures&.first
      next if version_name.blank? || build.blank?

      "#{version_name},#{build}"
    end
  end

  depends_on macos: :catalina
  container nested: "DoubaoImeInstaller_v#{version.csv.second}.app/Contents/Resources/DoubaoIme.zip"

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

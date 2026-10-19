cask "doubao-ime" do
  version "1.0.2,1000207,release_20261010_175807_23027789"
  sha256 "0cef9fa739d52b7603298e5d15024936e157371f156539333b2356681c1b07bc"

  url "https://lf-wave.doubaocdn.com/obj/doubao-ime/app/macos/DoubaoImeInstaller_v#{version.csv.second}_#{version.csv.third}.zip"
  name "Doubao Input Method"
  name "豆包输入法"
  desc "AI input method"
  homepage "https://shurufa.doubao.com/pc"

  livecheck do
    url "https://shurufa.doubao.com/api/v1/app/download_url?platform=macos"
    strategy :json do |json|
      version_name = json.dig("data", "version_name")&.delete_prefix("V")
      download_url = json.dig("data", "url")
      # installer filename format: DoubaoImeInstaller_v<build>_<release-suffix>.zip
      build_match = download_url&.match(%r{DoubaoImeInstaller_v(\d+)_([^/]+)\.zip}i)
      build = build_match&.[](1)
      release_suffix = build_match&.[](2)
      next if version_name.blank? || build.blank? || release_suffix.blank?

      "#{version_name},#{build},#{release_suffix}"
    end
  end

  depends_on :macos
  container nested: "DoubaoImeInstaller_v#{version.csv.second}.app/Contents/Resources/DoubaoIme.zip"

  input_method "DoubaoIme.app", target: "/Library/Input Methods/DoubaoIme.app"

  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-d", "-r", "com.apple.quarantine", "/Library/Input Methods/DoubaoIme.app"],
        must_succeed: false,
        sudo:         true
    run "/usr/bin/killall",
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

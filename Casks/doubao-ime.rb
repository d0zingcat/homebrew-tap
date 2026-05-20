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

  installer_resources = "DoubaoImeInstaller_v#{version}.app/Contents/Resources"
  install_script = "#{installer_resources}/install.sh"

  postflight do
    ime_path = "/Library/Input Methods/DoubaoIme.app"
    settings_app = "#{ime_path}/Contents/DoubaoImeSettings.app"
    bundle_id = "com.bytedance.inputmethod.doubaoime"
    input_mode = "com.bytedance.inputmethod.doubaoime.pinyin"
    hitoolbox = Pathname(Dir.home)/"Library/Preferences/com.apple.HIToolbox.plist"
    plist_buddy = "/usr/libexec/PlistBuddy"
    vendor_install = staged_path.join(install_script)

    if vendor_install.exist?
      system_command "/bin/sh",
                     args:         [vendor_install.to_s],
                     env:          { "APP_NAME" => "DoubaoIme" },
                     must_succeed: false,
                     sudo:         true
    else
      odebug "Doubao vendor install.sh not found at #{vendor_install}, skipping"
    end

    unless File.directory?(ime_path)
      odie "Doubao IME was not installed to #{ime_path}"
    end

    system_command "/usr/bin/xattr",
                   args:         ["-d", "-r", "com.apple.quarantine", ime_path],
                   must_succeed: false,
                   sudo:         true

    register_script = <<~SWIFT
      import Carbon

      let path = "#{ime_path}" as CFString
      guard let url = CFURLCreateWithFileSystemPath(nil, path, .cfurlposixPathStyle, true) else {
        fputs("failed to create URL\\n", stderr)
        exit(1)
      }

      let regStatus = TISRegisterInputSource(url)
      if regStatus != noErr {
        fputs("TISRegisterInputSource failed: \\(regStatus)\\n", stderr)
        exit(regStatus)
      }

      let bundleId = "#{bundle_id}" as CFString
      let props = [kTISPropertyBundleID: bundleId] as CFDictionary
      guard let unmanaged = TISCreateInputSourceList(props, true) else {
        fputs("TISCreateInputSourceList failed\\n", stderr)
        exit(1)
      }

      let sources = unmanaged.takeRetainedValue() as! [TISInputSource]
      for source in sources {
        TISEnableInputSource(source)
      }
    SWIFT

    script_path = "#{Dir.tmpdir}/doubao-ime-register-#{Process.pid}.swift"
    File.write(script_path, register_script)
    system_command "/usr/bin/swift",
                   args:         [script_path],
                   must_succeed: false
    FileUtils.rm_f(script_path)

    unless hitoolbox.exist? && File.read(hitoolbox).include?(bundle_id)
      unless hitoolbox.exist?
        hitoolbox.dirname.mkpath
        FileUtils.touch(hitoolbox)
        system_command plist_buddy,
                       args:         ["-c", "Add :AppleEnabledInputSources array", hitoolbox.to_s],
                       must_succeed: false
        idx = 0
      else
        output = shell_output(plist_buddy, "-c", "Print :AppleEnabledInputSources", hitoolbox.to_s)
        idx = output.lines.count { |line| line.strip.start_with?("Dict {") }
      end

      system_command plist_buddy,
                     args:         [
                       "-c",
                       "Add :AppleEnabledInputSources:#{idx} dict",
                       hitoolbox.to_s,
                     ],
                     must_succeed: false
      system_command plist_buddy,
                     args:         [
                       "-c",
                       "Add :AppleEnabledInputSources:#{idx}:InputSourceKind string Keyboard Input Method",
                       hitoolbox.to_s,
                     ],
                     must_succeed: false
      system_command plist_buddy,
                     args:         [
                       "-c",
                       "Add :AppleEnabledInputSources:#{idx}:'Bundle ID' string #{bundle_id}",
                       hitoolbox.to_s,
                     ],
                     must_succeed: false

      idx += 1
      system_command plist_buddy,
                     args:         [
                       "-c",
                       "Add :AppleEnabledInputSources:#{idx} dict",
                       hitoolbox.to_s,
                     ],
                     must_succeed: false
      system_command plist_buddy,
                     args:         [
                       "-c",
                       "Add :AppleEnabledInputSources:#{idx}:InputSourceKind string Input Mode",
                       hitoolbox.to_s,
                     ],
                     must_succeed: false
      system_command plist_buddy,
                     args:         [
                       "-c",
                       "Add :AppleEnabledInputSources:#{idx}:'Bundle ID' string #{bundle_id}",
                       hitoolbox.to_s,
                     ],
                     must_succeed: false
      system_command plist_buddy,
                     args:         [
                       "-c",
                       "Add :AppleEnabledInputSources:#{idx}:'Input Mode' string #{input_mode}",
                       hitoolbox.to_s,
                     ],
                     must_succeed: false
    end

    system_command "/usr/bin/defaults",
                   args:         ["write", "com.apple.HIToolbox", "AppleInputSourceUpdateTime", "-date", Time.now.utc.strftime("%Y-%m-%d %H:%M:%S %z")],
                   must_succeed: false

    system_command "/usr/bin/open",
                   args:         [ime_path],
                   must_succeed: false

    if File.directory?(settings_app)
      system_command "/usr/bin/open",
                     args:         [settings_app],
                     must_succeed: false
    end

    system_command "/usr/bin/open",
                   args:         ["x-apple.systempreferences:com.apple.Keyboard-Settings.extension"],
                   must_succeed: false

    %w[cfprefsd TextInputMenuAgent TextInputSwitcher SystemUIServer].each do |daemon|
      system_command "/usr/bin/killall",
                     args:         [daemon],
                     must_succeed: false
    end
  end

  uninstall delete: [
    "/Library/Input Methods/DoubaoIme.app",
    "/Library/Input Methods/OceanIme.app",
  ]

  caveats do
    <<~EOS
      If 豆包输入法 does not appear in System Settings immediately:

      1. In the Keyboard settings pane that opens, click "Edit…" (编辑) next to Input Sources.
      2. Click "+" and add "Doubao Input Method" / 豆包输入法.
      3. Ensure "Show Input menu in menu bar" is enabled, then switch from the menu bar icon.

      On some macOS versions the input method only becomes selectable after logging out
      and back in once. This matches the official installer behavior.
    EOS
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
end

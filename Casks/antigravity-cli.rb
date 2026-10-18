cask "antigravity-cli" do
  folder_arch = on_arch_conditional arm: "arm", intel: "x64"
  file_arch = on_arch_conditional arm: "arm64", intel: "x64"
  livecheck_arch = on_arch_conditional arm: "arm64", intel: "amd64"

  version "1.4.2,4835981233356800"
  sha256 arm:   "4fed2474da314f109cf505f1325eb84307afcd586242e6b691f074fd1a73e6aa",
         intel: "a81f6a49d3fe1c07919ed332f2363f95109549fdd0195cbe8344d226edafd4e3"

  url "https://storage.googleapis.com/antigravity-public/antigravity-cli/#{version.csv.first}-#{version.csv.second}/darwin-#{folder_arch}/cli_mac_#{file_arch}.tar.gz"
  name "Google Antigravity CLI"
  desc "Terminal interface for Antigravity agents"
  homepage "https://antigravity.google/product/antigravity-cli"

  livecheck do
    url "https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests/darwin_#{livecheck_arch}.json"
    regex(%r{/antigravity-cli/([^/]+)/}i)
    strategy :json do |json, regex|
      match = json["url"]&.match(regex)
      next if match.blank?

      match[1]&.tr("-", ",").to_s
    end
  end

  auto_updates true
  depends_on macos: :monterey

  binary "antigravity", target: "antigravity-cli"

  zap trash: "~/.gemini/antigravity-cli"
end

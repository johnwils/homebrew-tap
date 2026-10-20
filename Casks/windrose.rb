cask "windrose" do
  version "0.7.4"
  sha256 "442d4f4fe107f50e611b2e1f4569b1f0662e2f559770a49df2c70a1f303e8c81"

  url "https://updates.index9.dev/windrose/releases/Windrose-#{version}.dmg",
      verified: "updates.index9.dev/windrose/"
  name "Windrose"
  desc "Fan control for Apple Silicon Macs"
  homepage "https://index9.dev/windrose"

  livecheck do
    url "https://updates.index9.dev/windrose/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on arch: :arm64
  # Real floor is macOS 13.3 (LSMinimumSystemVersion). Homebrew can only say
  # Ventura (13.0); macOS itself refuses to launch the app below 13.3.
  depends_on macos: ">= :ventura"

  app "Windrose.app"

  uninstall quit: "dev.index9.windrose"

  # Root state (SMAppService daemon, /Library/Application Support/Windrose) is
  # deliberately not touched: Homebrew can't unregister a BTM item. Run
  # Windrose's own "Uninstall Fan Service…" first.
  zap trash: [
    "~/Library/Application Support/Windrose",
    "~/Library/Caches/dev.index9.windrose",
    "~/Library/HTTPStorages/dev.index9.windrose",
    "~/Library/Preferences/dev.index9.windrose.plist",
    "~/Library/WebKit/dev.index9.windrose",
  ]

  caveats <<~EOS
    Windrose must stay in /Applications for its fan service to register.
    Before `brew uninstall --zap`, open Windrose and use
    ⋯ → Uninstall Fan Service… so the privileged helper is removed cleanly.
  EOS
end

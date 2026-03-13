class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "1807b2630d3f5876e3161e377c97c1f111a82d4923609ecb05a56820238c95df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "991a6d97d7d461532df34dd4d05412fbb77587fc6c8a4222a8bfd5af9515c66d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ec97922d01295ef23cbd8a59245d09dd8b3c0475e44ad95c9a745c75ab88950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7048fdb1971a60544f150c28a838fec97bfe6f050b309cb55ff7cfd41f1a74e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a5dbf7484dbe4ce60996359f28c68d8935945564acce45f7c27ef701ddf1ae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87497b3ae1c496674d241b770d7ac39d939b48014bb7210be5d40e4a74f7043c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669d9b6755d7315b66a7acff8d4d890680beb4e7118acc35aeef519f13000a2c"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end

class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.18.3.tgz"
  sha256 "d1ab13032602c2710a2267587b3bfd466752e1332e5374bb658ee95d1c79fed0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0890f6d1be97e592f773b31f9bb83c206a1264644e3e1952267c0e09e6cbc194"
    sha256 cellar: :any,                 arm64_sequoia: "a88cf14acf04157409784fad9e8c4ee48181b6125a7137411ce1b0ea22dbbf2a"
    sha256 cellar: :any,                 arm64_sonoma:  "a88cf14acf04157409784fad9e8c4ee48181b6125a7137411ce1b0ea22dbbf2a"
    sha256 cellar: :any,                 sonoma:        "9b522ab6ec71e8cd5f6a2df1678d5883214fb681ff0bb4e14dec6f1b5dcee26a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26bfbc03e5f6be97b04da04ddf048f30ce3e84bdec02f999e7ed190fd3d263de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8835ef0a0b9b4681dcdb60dffd5d7d5b8383c9d225b5cd92891a7c88944cd01d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end

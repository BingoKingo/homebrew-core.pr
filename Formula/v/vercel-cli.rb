class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.1.3.tgz"
  sha256 "0e1f810c1ec4212a395612ab7c119b88c94ec6f3e2228df1d3877ed8e4f114aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8e0ac50e3ce6618b908cb9eb6dc79677cc31c0c9f01d81d2060e5fc0b3c0193"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e0ac50e3ce6618b908cb9eb6dc79677cc31c0c9f01d81d2060e5fc0b3c0193"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8e0ac50e3ce6618b908cb9eb6dc79677cc31c0c9f01d81d2060e5fc0b3c0193"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb4b405678a4bc27814e45866aec99d8e5dca9a53d523297cb0abb9aad9652e"
    sha256 cellar: :any_skip_relocation, ventura:       "5cb4b405678a4bc27814e45866aec99d8e5dca9a53d523297cb0abb9aad9652e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3fa2ea632b04bd28586c633347dd35c3451b62a2feacfe662a54c482f840c1f"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end

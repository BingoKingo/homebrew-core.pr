class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-41.1.1.tgz"
  sha256 "e626ae1752ce96e9725c064b7965a107b1f57d22bbb5cc3add57b59a52d5385a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29899522df15d22945ca4a100e03217c10bf1d45ca311ab75eabe4411afa5b5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29899522df15d22945ca4a100e03217c10bf1d45ca311ab75eabe4411afa5b5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29899522df15d22945ca4a100e03217c10bf1d45ca311ab75eabe4411afa5b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee5db560dc50ed954b860037e77ac5b1343bfb950e6badba518d48fd4277bec"
    sha256 cellar: :any_skip_relocation, ventura:       "0ee5db560dc50ed954b860037e77ac5b1343bfb950e6badba518d48fd4277bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001e595aab633e796590cecc2c2388a379086822c9a0617314c5be9cc965065a"
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

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.38.tgz"
  sha256 "54ebd04ee2cef8bb9fa911a6cc56336c7a6184bbb8841dd7c36cf7d6336b2d79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dca530b78bb161e25937916ec877289523f369f5601edfb9e620404f6ecb711d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end

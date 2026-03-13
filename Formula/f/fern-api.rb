class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.27.0.tgz"
  sha256 "6ac758e2aeb3602bc8508562206687166e65b1a505b12c11163c032ac900f614"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57ce833c75a5e4da4e1b27cd918ae7b0321e0ce514a9a283e382d4bafc20f5d5"
    sha256 cellar: :any,                 arm64_sequoia: "8793f3806364b515a690dfd51cb9afdcbc0c3ce30c028e04d9581a91228c26eb"
    sha256 cellar: :any,                 arm64_sonoma:  "8793f3806364b515a690dfd51cb9afdcbc0c3ce30c028e04d9581a91228c26eb"
    sha256 cellar: :any,                 sonoma:        "67f26b2789906cad1cf36eee7acc921bc0815894cd0d2a26f9f0701396cc98bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a15c3d70f676dbc9198571dd6948ef12217751a9c9e19c145ffb4bafd4ab6330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "970722010011626f115016d27152cb7536173f35a246630c83e1d0553862976c"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end

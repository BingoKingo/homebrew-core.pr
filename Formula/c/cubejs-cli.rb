class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.1.tgz"
  sha256 "4081b8b378f4bb5d7f592b271c54793cd14b83a108ee9db291c0ea52a46765cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "159dc5444a1d0775db75e0abc03f139c8224ef418549bfa9b86724c38a69872a"
    sha256 cellar: :any,                 arm64_sonoma:  "159dc5444a1d0775db75e0abc03f139c8224ef418549bfa9b86724c38a69872a"
    sha256 cellar: :any,                 arm64_ventura: "159dc5444a1d0775db75e0abc03f139c8224ef418549bfa9b86724c38a69872a"
    sha256 cellar: :any,                 sonoma:        "4f428e1e774d246acd9dc509cd7479747ccf5aa8c2bd11a274b21ed0a7a6663e"
    sha256 cellar: :any,                 ventura:       "4f428e1e774d246acd9dc509cd7479747ccf5aa8c2bd11a274b21ed0a7a6663e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf6d927da547378cb64f5c32381cfc003e25c478aa8da4658f37feb1d20469b6"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end

class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.41.2.tar.gz"
  sha256 "0e60fc955bf991586387ea4281bc9120cabf556d10f4a14b86bb57b6c96cf2dd"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "439bca4d26983f4ba65414e80971e521ae237b9f38d4d35bf77a2981e73b50f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a5d1edd06eb0c8e2c58fb605f35c805ccefe92ec25056e2401e3352ebb6730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36648b4b393b97091f161a2feab69bf0c540c7f3d92940aeef59326f396b254f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8320080cbfc4bc1de59e94733f5c05b1060c05e52a7295e0eeb9022a682df684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "849a90a3290fac31dd71277d013b3ce96dd97d8b9f72c37d940b314422ef5641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19f1818f504ea360d7c8a3b0ab35d071bb7ecb2ac028209f430107eff9c1791e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end

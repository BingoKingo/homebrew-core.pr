class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "303ad8cab54fcc6b1b08c5dd39d7fbfc9116a7eace1d924fc549985b14840049"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "518033452c58fc128c6a7c755bb4ce4d08ddae5c49ac85ce911f3c85f16fc918"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "518033452c58fc128c6a7c755bb4ce4d08ddae5c49ac85ce911f3c85f16fc918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "518033452c58fc128c6a7c755bb4ce4d08ddae5c49ac85ce911f3c85f16fc918"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6975d638e4bffe65baf05766fddb0321e4f6702fa1d0ad4c2573e59c40096ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2634377e30e3f9cbd86eea46c4cc0ba930f80f25ada853b57785dd09f3f441f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35fa425e7fa8e0ee71a410aec5101485b21ff482aa363a915c248300e7c336c"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end

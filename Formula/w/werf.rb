class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "6bc1c891e8c32ffefcf2bd078beef80c62105ea67b5bcbf575d7723f7b6a45f3"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c35210628f888361f4a4be35e63c6fb20ebec5ef2931307fa6393ab6ce13c455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1035d27ac616702c7fec0db1054372bc930040d52e5b99c99188c2e38a5ffc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3dd5616ca6e33da34d2f5285d223c8e8b7a491791f543f471f518da62920162"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c69a759e0b8ac8f013dacb8a60595f55b541bfd7e8e52be326a422515e8d65"
    sha256 cellar: :any_skip_relocation, ventura:       "b7c5933618d8e4e728ce92246f1585e501dcac8a5ac4135c6b88eef80c2d5de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "042e332e7a284d041c5f47f2f28f295a399d4cead5d774c5835da7938c161bdf"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~YAML
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    YAML

    output = <<~YAML
      - image: vote
      - image: result
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end

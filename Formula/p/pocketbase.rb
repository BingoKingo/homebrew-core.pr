class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "78602e235e54252c7ca55a45893fe706c8244c266aab5c98c5d57558eb8d8ecd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29c935aefbfdd20e55daa0a22848c37ece3edf85ba04288c9e981029dd9d0e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29c935aefbfdd20e55daa0a22848c37ece3edf85ba04288c9e981029dd9d0e55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29c935aefbfdd20e55daa0a22848c37ece3edf85ba04288c9e981029dd9d0e55"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac15d756770f1cdf2f1c347664aae46dabd16b319de3af3b450fbe203a11d8f"
    sha256 cellar: :any_skip_relocation, ventura:       "2ac15d756770f1cdf2f1c347664aae46dabd16b319de3af3b450fbe203a11d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb486887abf7ca95dbd894743c86c583479a3ed07190c67face5914788f3ef6"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    _, _, pid = PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}")
    sleep 5

    system "nc", "-z", "localhost", port

    assert_path_exists testpath/"pb_data", "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
    assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
  ensure
    Process.kill "TERM", pid
  end
end

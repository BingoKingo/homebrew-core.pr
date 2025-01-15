class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "1dfbb1c0f4ee58991470731099181995311e177f5daabc21b080b5cef7643e0b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32e33354610c057cfbdfca4ca35502875cd3a4ab3ad87429d5bf4d7e4b2d949b"
    sha256 cellar: :any,                 arm64_sonoma:  "7ca8f49a3c1b57451c0a1f91708d759c0d3534c991c26c1404a69306d408212d"
    sha256 cellar: :any,                 arm64_ventura: "461d67bb24c4edff917c20e0417dc55e9c10037e2d0ce09b166942564b9c04a3"
    sha256 cellar: :any,                 sonoma:        "f70d8e8345859670008b586861980f61f9a7cd360d53697141bffc62720dfabf"
    sha256 cellar: :any,                 ventura:       "eae5ee5b102ff4a9ac979a751ad759cb2f367aaf84eade0b355fb2dbc494081e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8361ea8a984043dd9f976e020aa90e6f04b7511c6f1d767289ca98859dbac04"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end

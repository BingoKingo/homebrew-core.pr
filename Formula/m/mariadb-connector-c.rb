class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://mariadb.org/download/?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https://archive.mariadb.org/connector-c-3.4.5/mariadb-connector-c-3.4.5-src.tar.gz"
  mirror "https://fossies.org/linux/misc/mariadb-connector-c-3.4.5-src.tar.gz/"
  sha256 "b17e193816cb25c3364c2cc92a0ad3f1d0ad9f0f484dc76b8e7bdb5b50eac1a3"
  license "LGPL-2.1-or-later"
  head "https://github.com/mariadb-corporation/mariadb-connector-c.git", branch: "3.4"

  # The REST API may omit the newest major/minor versions unless the
  # `olderReleases` parameter is set to `true`.
  livecheck do
    url "https://downloads.mariadb.org/rest-api/connector-c/all-releases/?olderReleases=true"
    strategy :json do |json|
      json["releases"]&.map do |_, group|
        group["children"]&.map do |release|
          next if release["status"] != "stable"

          release["release_number"]
        end
      end&.flatten
    end
  end

  bottle do
    sha256 arm64_sequoia: "a2ac7c1cec93be4f68508b4a1f8859c23e07e8bf44053027826d902e4d8bf6ed"
    sha256 arm64_sonoma:  "0dda6d594349a40127af8a5b10847dc50eebb0f4978a61ae141ca1f4b2104100"
    sha256 arm64_ventura: "f7255cdf8e6dec5e2b430d95624a25b8b95bc4d0c522bc82257b02c708e2880a"
    sha256 sonoma:        "636191115f0cc0829927d13553c7bf4dc0f1eae5f71e0c807fdb5aa74e426383"
    sha256 ventura:       "b2a6bda80bca6974d6a2687d402ff05084ea8401aef6c48b80fe3bed2ecb9b5a"
    sha256 arm64_linux:   "0b20a403d7a9595c360ffa68183c3c8ec30f9e253539f959f031396877a9bd4c"
    sha256 x86_64_linux:  "5002625fb3830229f79aa43f8b72123a98c61c7f5582478f6b54e221f159468a"
  end

  keg_only "it conflicts with mariadb"

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    rm_r "external"

    # -DINSTALL_* are relative to prefix
    args = %w[
      -DINSTALL_LIBDIR=lib
      -DINSTALL_MANDIR=share/man
      -DWITH_EXTERNAL_ZLIB=ON
      -DWITH_MYSQLCOMPAT=ON
      -DWITH_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Add mysql_config symlink for compatibility which simplifies building
    # some dependents. This is done in the full `mariadb` installation[^1]
    # but not in the standalone `mariadb-connector-c`.
    #
    # [^1]: https://github.com/MariaDB/server/blob/main/cmake/symlinks.cmake
    bin.install_symlink "mariadb_config" => "mysql_config"

    # Temporary symlinks for backwards compatibility.
    # TODO: Remove in future version update.
    (lib/"mariadb").install_symlink lib.glob(shared_library("*"))

    # TODO: Automatically compress manpages in brew
    Utils::Gzip.compress(*man3.glob("*.3"))
  end

  test do
    system bin/"mariadb_config", "--cflags"
  end
end

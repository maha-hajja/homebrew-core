class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.14.0",
      revision: "ec9686a4b922e278614ed1754d308c75eaa59586"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2f59c648b0f020b0275be4ea4802e5cba1d0a9e8f2faa9c5c0fc3ff0763738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2f59c648b0f020b0275be4ea4802e5cba1d0a9e8f2faa9c5c0fc3ff0763738"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb2f59c648b0f020b0275be4ea4802e5cba1d0a9e8f2faa9c5c0fc3ff0763738"
    sha256 cellar: :any_skip_relocation, sonoma:        "2feef09062ba1bb20cc22aeabafd8231cc82f3d60971ea751e769eb69f9a03d5"
    sha256 cellar: :any_skip_relocation, ventura:       "2feef09062ba1bb20cc22aeabafd8231cc82f3d60971ea751e769eb69f9a03d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81625f69d7a682ec4c0b3c2dd67a851544ba95a38d3c7afc3dc225c4eb37b2a8"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end

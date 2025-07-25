{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lib,
  libiconv,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "wireguard-exporter";
  version = "3.6.6";

  src = fetchFromGitHub {
    owner = "MindFlavor";
    repo = "prometheus_wireguard_exporter";
    rev = version;
    sha256 = "sha256-2e31ZuGJvpvu7L2Lb+n6bZWpC1JhETzEzSiNaxxsAtA=";
  };

  cargoHash = "sha256-PVjeCKGHiHo+OtjIxMZBBJ19Z3807R34Oyu/HYZO90U=";

  postPatch = ''
    # drop hardcoded linker names, fixing static build
    rm .cargo/config.toml
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) wireguard; };

  meta = with lib; {
    description = "Prometheus exporter for WireGuard, written in Rust";
    homepage = "https://github.com/MindFlavor/prometheus_wireguard_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [
      ma27
      globin
    ];
    mainProgram = "prometheus_wireguard_exporter";
  };
}

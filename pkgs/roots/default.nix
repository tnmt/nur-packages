{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

buildGoModule rec {
  pname = "roots";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "roots";
    rev = "v${version}";
    hash = "sha256-neK1K3Emam70LJR/oVi1Gn0dNM+OC6X5TyAufQJE7BQ=";
  };

  vendorHash = "sha256-po/kY9zXId2qvk3oNgdrgFLEbVIWedYjfqMfdX4J5Ls=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/roots/version.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for exploring multiple root directories, such as those in a monorepo project";
    homepage = "https://github.com/k1LoW/roots";
    license = lib.licenses.mit;
    mainProgram = "roots";
  };
}

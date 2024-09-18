{ lib
, rustPlatform
, buildNpmPackage
, fetchFromGitHub
,webkitgtk
,nodejs_18
, libiconv
,rustc
, cargo
,cacert
, stdenv
, darwin, ...
}:

let pkgs23 = import(fetchTarball
    ("https://codeload.github.com/NixOS/nixpkgs/zip/refs/tags/23.05")) {};
in

#stdenv.mkDerivation
rustPlatform.buildRustPackage rec {
  pname = "desktop-postflop";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "b-inary";
    repo = "desktop-postflop";
    rev = "v${version}";
    hash = "sha256-pOPxNHM4mseIuyyWNoU0l+dGvfURH0+9+rmzRIF0I5s=";
  };

  npmDist = buildNpmPackage {
    name = "${pname}-${version}-dist";
    inherit src;

    npmDepsHash = "sha256-HWZLicyKL2FHDjZQj9/CRwVi+uc/jHmVNxtlDuclf7s=";

    installPhase = ''
      mkdir -p $out
      cp -r dist/* $out
    '';
  };

  sourceRoot = "${src.name}/src-tauri";


  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "postflop-solver-0.1.0" = "sha256-coEl09eMbQqSos1sqWLnfXfhujSTsnVnOlOQ+JbdFWY=";
    };
  };

  patches = [
		./0001-turn_off_custom_alloc.patch
  ];
  postPatch = ''
    #substituteInPlace tauri.conf.json \
     #   --replace "../dist" "${npmDist}"
 '';





  buildInputs = [
  # New version of rustc breaks the dependency: `time`. Use 1.69
    pkgs23.rustc
    pkgs23.cargo
    pkgs23.libiconv

    nodejs_18

    #webkitgtk

    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
    darwin.apple_sdk.frameworks.WebKit

	cacert
  ];

  #buildPhase = ''
    #ls
	#cat tauri.conf.json
	#npm install
	#CI=true npm run tauri build --verbose
  #'';

  postInstall = ''
	ls
	pwd
	ls $out
    install -Dm644 ${src}/public/favicon.png $out/share/icons/hicolor/128x128/apps/desktop-postflop.png
  '';

  meta = with lib; {
    changelog = "https://github.com/b-inary/desktop-postflop/releases/tag/${src.rev}";
    description = "Free, open-source GTO solver for Texas hold'em poker";
    homepage = "https://github.com/b-inary/desktop-postflop";
    license = lib.licenses.agpl3Plus;
    mainProgram = "desktop-postflop";
    maintainers = with lib.maintainers; [ endle ];
    platforms = platforms.darwin;
  };
}

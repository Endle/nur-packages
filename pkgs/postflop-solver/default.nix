{ lib
, stdenv
,cacert
, fetchFromGitHub
,webkitgtk
,nodejs_18
, libiconv
,rustc
, cargo
, darwin, ...
}:

let pkgs23 = import(fetchTarball
    ("https://codeload.github.com/NixOS/nixpkgs/zip/refs/tags/23.05")) {};
in

stdenv.mkDerivation rec {
  pname = "desktop-postflop";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "b-inary";
    repo = "desktop-postflop";
    rev = "v${version}";
    hash = "sha256-pOPxNHM4mseIuyyWNoU0l+dGvfURH0+9+rmzRIF0I5s=";
  };




  patches = [
		./0001-turn_off_custom_alloc.patch
  ];


  buildPhase = ''
	npm install
	CI=true npm run tauri build --verbose
  '';


  installPhase = ''
    mkdir -p $out/bin
    cp -r "src-tauri/target/release/bundle/macos/Desktop Postflop.app" $out/bin
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

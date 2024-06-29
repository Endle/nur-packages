{ lib , ... }: 
with import <nixpkgs>
{
  overlays = [
    (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
  ];
};
let
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
in

rustPlatform.buildRustPackage rec {
  pname = "postflop-solver";
  version = "v0.2.7";

  src = fetchFromGitHub {
    owner = "b-inary";
    repo = "desktop-postflop";
    rev = "${version}";
    sha256 = "sha256-pOPxNHM4mseIuyyWNoU0l+dGvfURH0+9+rmzRIF0I5s=";
  };

#cargoSha256 = lib.fakeSha256;
sourceRoot="source/src-tauri";
cargoLock = {
	lockFile = ./src-tauri/Cargo.lock;
	#lockFile = ./Cargo.lock;
};

  nativeBuildInputs = [ 
    swift 
    swiftpm
  ];

  buildInputs = [
    swiftPackages.XCTest
    libiconv
  ];

  buildPhase = ''
  	ls
	rustc -v
  '';


  installPhase = ''
    mkdir -p $out/bin
    cp .build/release/xcodegen $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/yonaskolb/XcodeGen";
    description = "A Swift command line tool for generating your Xcode project";
    longDescription = ''
      XcodeGen is a command line tool written in Swift that generates your Xcode project using your folder structure and a project spec.
    '';
    license = licenses.agpl3;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ endle ];
  };
}

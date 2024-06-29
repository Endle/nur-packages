{ lib
, stdenv
, fetchFromGitHub
, swift
, swiftpm
, swiftpm2nix
, swiftPackages
}:

stdenv.mkDerivation rec {
  pname = "xcodegen";
  version = "v0.2.7";

  src = fetchFromGitHub {
    owner = "b-inary";
    repo = "desktop-postflop";
    rev = "${version}";
    sha256 = "sha256-pOPxNHM4mseIuyyWNoU0l+dGvfURH0+9+rmzRIF0I5s=";
  };


  nativeBuildInputs = [ 
    swift 
    swiftpm
  ];

  buildInputs = [
    swiftPackages.XCTest
  ];

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

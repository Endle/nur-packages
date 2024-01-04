{ lib
, stdenv
, fetchFromGitHub
, swift
, swiftpm
, swiftPackages
, darwin
, xcbuild
, cacert # Required by git during build process
}:

stdenv.mkDerivation rec {
  pname = "xcodegen";
  version = "2.38.0";

  src = fetchFromGitHub {
    owner = "nikitabobko";
    repo = "AeroSpace";
    rev = "${version}";
    sha256 = "sha256-5N0ZNQec1DUV4rWqqOC1Aikn+RKrG8it0Ee05HG2mn4=";
  };

  patches = [
  ];


  nativeBuildInputs = [
    darwin.apple_sdk.frameworks.Foundation
  ];

  buildInputs = [
    swift
    swiftpm
    darwin.apple_sdk.frameworks.Foundation
    swiftPackages.XCTest
    swiftPackages.Foundation
    xcbuild # for xcrun
    cacert
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp .build/release/xcodegen $out/bin
  '';

  enableParallelBuilding = true;


  meta = with lib; {
    homepage = "https://github.com/nikitabobko/AeroSpace";
    "https://github.com/yonaskolb/XcodeGen";
    description = " an i3-like tiling window manager for macOS";
    longDescription = ''
      XcodeGen is a command line tool written in Swift that generates your Xcode project using your folder structure and a project spec.
    '';
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ endle ];
  };
}

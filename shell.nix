with import <nixpkgs> { };
let
  default = callPackage ./. { };

in mkShell rec {
  name = "iplay";
  buildInputs = default.nativeBuildInputs ++ default.buildInputs ++ [ dpkg ];
  shellHook = ''
    echo Welcome to ${name} environment.
  '';
}

with import <nixpkgs> { };
let
  default = callPackage ./. { };

in mkShell rec {
  name = "iplay";
  buildInputs = default.nativeBuildInputs;
  shellHook = ''
    export PATH+=:$PWD
    echo Welcome to ${name} environment.
  '';
}

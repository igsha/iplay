{ stdenv, ag, bash, fzy, httpie, mpv, libxml2, which, jq, openssl, youtube-dl, cmake, perlPackages }:

let
  cmakeVersionRegex = ".*project\\(.*VERSION ([[:digit:]\.]+).*";
  version = builtins.head (builtins.match cmakeVersionRegex (builtins.readFile ./CMakeLists.txt));

in stdenv.mkDerivation rec {
  pname = "iplay";
  inherit version;

  src = ./.;

  nativeBuildInputs = [ cmake perlPackages.podlators ];
  propagatedNativeBuildInputs = [ ag bash fzy httpie mpv libxml2 which jq openssl youtube-dl ];

  meta = with stdenv.lib; {
    description = "An interactive video player capable to work with urls";
    homepage = https://github.com/igsha/iplay;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ igsha ];
  };
}

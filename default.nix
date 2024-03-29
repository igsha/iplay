{ stdenv, lib, makeWrapper, silver-searcher, bash, fzy, httpie, mpv, libxml2, which, jq, openssl, youtube-dl, cmake, pandoc }:

let
  cmakeVersionRegex = ".*project\\(.*VERSION ([[:digit:]\\.]+).*";
  version = builtins.head (builtins.match cmakeVersionRegex (builtins.readFile ./CMakeLists.txt));

in stdenv.mkDerivation rec {
  pname = "iplay";
  inherit version;

  src = ./.;

  buildInputs = [ cmake pandoc makeWrapper ];
  nativeBuildInputs = [ silver-searcher bash fzy httpie mpv libxml2 which jq openssl youtube-dl ];
  postInstall = ''
    wrapProgram $out/bin/iplay --prefix PATH : ${lib.makeBinPath nativeBuildInputs}
  '';

  meta = with lib; {
    description = "An interactive video player capable to work with urls";
    homepage = https://github.com/igsha/iplay;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ igsha ];
  };
}

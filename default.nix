{ stdenv, ag, bash, fzf, httpie, mpv, libxml2, which, jq, openssl, youtube-dl }:

let
  version = builtins.head (builtins.match ".*__version=([[:digit:]\.]+).*" (builtins.readFile ./iplay));

in stdenv.mkDerivation rec {
  pname = "iplay";
  inherit version;

  src = ./.;

  nativeBuildInputs = [ ag bash fzf httpie mpv libxml2 which jq openssl youtube-dl ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    find . -maxdepth 1 -type f -a -executable | xargs -I{} cp {} $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "An interactive video player capable to work with urls";
    homepage = https://github.com/igsha/iplay;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ igsha ];
  };
}

{
  description = "liquidsfz";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "liquidsfz";
          version = "0.3.2";
          src = pkgs.fetchFromGitHub {
            owner = "swesterfeld";
            repo = "liquidsfz";
            rev = "0.3.2";
						hash = "sha256-yIkHUg6q6d+YS9x0+fWEhl65urT9KI73y+W71g2SOoA="; # вставь хеш из ошибки nix build
          };
          nativeBuildInputs = with pkgs; [ autoreconfHook pkg-config ];
          buildInputs = with pkgs; [ libsndfile lv2 readline jack2 ];
					postPatch = ''
						sed -i '1i #include <algorithm>' tests/testsynth.cc
						sed -i '1i #include <termios.h>' src/liquidsfz.cc
						sed -i '1i #include <unistd.h>' src/liquidsfz.cc
					'';        };
      }
    );
}

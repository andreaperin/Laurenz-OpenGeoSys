{
  description = "Local OpenGeoSys 6.5.6 build flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.ogs = pkgs.stdenv.mkDerivation {
        pname = "opengeosys";
        version = "6.5.6";

        src = pkgs.fetchFromGitLab {
          # using GitLab since OpenGeoSys hosts on GitLab
          owner = "opengeosys";
          repo = "ogs";
          rev = "6.5.6";   
          sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        };

        nativeBuildInputs = [ pkgs.cmake pkgs.ninja ];
        buildInputs = with pkgs; [
          boost
          eigen
          vtk
          hdf5
          python3
        ];

        cmakeFlags = [
          "-DOGS_USE_PYTHON=ON"
          "-DOGS_BUILD_TESTS=OFF"
          "-DOGS_BUILD_GUI=OFF"
        ];

        buildPhase = ''
          cmake -S . -B build -G Ninja ${cmakeFlags}
          cmake --build build
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp build/bin/ogs $out/bin/
        '';

        meta = {
          description = "OpenGeoSys simulation code, version 6.5.6";
          license = pkgs.lib.licenses.mit;
          maintainers = with pkgs.lib.maintainers; [ ];
          platforms = [ "x86_64-linux" ];
        };
      };

      apps.${system}.ogs = {
        type = "app";
        program = "${self.packages.${system}.ogs}/bin/ogs";
      };

      devShells.${system}.default = pkgs.mkShell {
        name = "opengeosys-dev";
        buildInputs = with pkgs; [
          cmake
          ninja
          git
          gcc
          boost
          eigen
          vtk
          hdf5
          python3
          python3Packages.numpy
        ];
      };
    };
}

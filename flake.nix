{
    description = "Description for the project";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # devshell for some nice menu + easy command adding capabilities
        devshell = {
            url = "github:numtide/devshell";
            inputs.nixpkgs.follows = "nixpkgs";
        };


        # local user package managment
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

    };

    outputs = inputs@{ flake-parts, nixpkgs, home-manager, machines, ... }:
        flake-parts.lib.mkFlake { inherit inputs; } {
            imports = [
                # To import a flake module
                # 1. Add foo to inputs
                # 2. Add foo as a parameter to the outputs function
                # 3. Add here: foo.flakeModule
            ];
            systems = [ "x86_64-linux" ]; # "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
            perSystem = { config, self', inputs', pkgs, system, ... }: {
                # Per-system attributes can be defined here. The self' and inputs'
                # module parameters provide easy access to attributes of the same
                # system.

                # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
                # packages.default = pkgs.hello;
            };
            flake = {
                # The usual flake attributes can be defined here, including system-
                # agnostic ones like nixosModule and system-enumerating ones, although
                # those are more easily expressed in perSystem.
                # nixosConfiguration
                nixosConfiguration.core = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [
                        # import ./machines/core/default.nix

                        home-manager.nixosModules.home-manager {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;

                            # home-manager.users.jan = import ./users/jan/default.nix;
                        }
                    ];
                    specialArgs = { inherit inputs; };
                };
            };
        };
}

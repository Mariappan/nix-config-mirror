# Shamelssly copied from
# https://github.com/vimjoyer/nixconf/blob/4e6241430e8025b65391ce3819218318387f1ad3/myLib/default.nix#L1 (MIT)
{ inputs }:
let
  libx = (import ./default.nix) { inherit inputs; };
  outputs = inputs.self.outputs;
  nixpkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;
in
rec {
  # ================================================================ #
  # =                            My Lib                            = #
  # ================================================================ #

  # ======================= Package Helpers ======================== #

  pkgsFor = sys: inputs.nixpkgs.legacyPackages.${sys};

  # =========================== Helpers ============================ #

  filesIn = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));

  dirsIn =
    dir: inputs.nixpkgs.lib.filterAttrs (name: value: value == "directory") (builtins.readDir dir);

  dirsHiddenIn =
    dir:
    inputs.nixpkgs.lib.filterAttrs (
      name: value: value == "directory" && !inputs.nixpkgs.lib.strings.hasPrefix "_" name
    ) (builtins.readDir dir);

  dirsCleanIn =
    dir:
    inputs.nixpkgs.lib.filterAttrs (name: value: value == "directory" && name != "shared") (
      builtins.readDir dir
    );

  fileNameOf = path: (builtins.head (builtins.split "\\." (baseNameOf path)));

  # ==================== Feature Module Loader ===================== #

  # Load features from a directory with nested support
  # Creates options like:
  #   - Top-level files: {optionPrefix}.{name}.enable
  #   - Directories with default.nix: {optionPrefix}.{dirname}.enable
  #   - Other files in dirs: {optionPrefix}.{dirname}.{filename}.enable
  mkFeatures =
    {
      featuresDir, # Path to features directory
      config, # The config object
      lib, # The lib object
      optionPrefix, # e.g., "nixma.linux" or "nixma"
    }:
    let
      # Get config at the option prefix path
      cfg = lib.attrByPath (lib.splitString "." optionPrefix) { } config;

      # Get all entries in features directory
      allEntries = builtins.readDir featuresDir;

      # Top-level .nix files become {optionPrefix}.{name}.enable
      # Skip files starting with _ (data files, not modules)
      nixFiles = lib.filterAttrs (
        name: type: type == "regular" && lib.hasSuffix ".nix" name && !lib.hasPrefix "_" name
      ) allEntries;
      topLevelFeatures = libx.extendModules (name: {
        extraOptions = lib.setAttrByPath (lib.splitString "." "${optionPrefix}.${name}.enable") (
          lib.mkEnableOption "enable my ${name} configuration"
        );
        configExtension = config: (lib.mkIf cfg.${name}.enable config);
      }) (map (name: featuresDir + "/${name}") (builtins.attrNames nixFiles));

      # Directories become nested features
      directories = lib.filterAttrs (name: type: type == "directory") allEntries;
      nestedFeatures = lib.flatten (
        map (
          dirName:
          let
            dirPath = featuresDir + "/${dirName}";
            filesInDir = builtins.readDir dirPath;
            nixFilesInDir = lib.filterAttrs (
              name: type: type == "regular" && lib.hasSuffix ".nix" name && !lib.hasPrefix "_" name
            ) filesInDir;

            # Separate default.nix from other files
            defaultNix = if nixFilesInDir ? "default.nix" then [ (dirPath + "/default.nix") ] else [ ];
            otherNixFiles = lib.filterAttrs (name: type: name != "default.nix") nixFilesInDir;

            # default.nix creates {optionPrefix}.{dirname}.enable
            defaultFeature =
              if (builtins.length defaultNix > 0) then
                libx.extendModules (name: {
                  extraOptions = lib.setAttrByPath (lib.splitString "." "${optionPrefix}.${dirName}.enable") (
                    lib.mkEnableOption "enable ${dirName} configuration"
                  );
                  configExtension = config: (lib.mkIf cfg.${dirName}.enable config);
                }) defaultNix
              else
                [ ];

            # Other files create {optionPrefix}.{dirname}.{filename}.enable
            otherFeatures = libx.extendModules (fileName: {
              extraOptions = lib.setAttrByPath (lib.splitString "." "${optionPrefix}.${dirName}.${fileName}.enable") (
                lib.mkEnableOption "enable ${dirName} ${fileName} configuration"
              );
              configExtension = config: (lib.mkIf cfg.${dirName}.${fileName}.enable config);
            }) (map (name: dirPath + "/${name}") (builtins.attrNames otherNixFiles));
          in
          defaultFeature ++ otherFeatures
        ) (builtins.attrNames directories)
      );
    in
    topLevelFeatures ++ nestedFeatures;

  # ==================== Bundle Module Loader ====================== #

  # Load bundles from a directory
  # Creates options like: {optionPrefix}.bundle.{name}.enable
  mkBundles =
    {
      bundlesDir, # Path to bundles directory
      config, # The config object
      lib, # The lib object
      optionPrefix, # e.g., "nixma.linux" or "nixma"
    }:
    let
      # Get config at the option prefix path
      cfg = lib.attrByPath (lib.splitString "." optionPrefix) { } config;
    in
    libx.extendModules (name: {
      extraOptions = lib.setAttrByPath (lib.splitString "." "${optionPrefix}.bundle.${name}.enable") (
        lib.mkEnableOption "enable ${name} module bundle"
      );
      configExtension = config: (lib.mkIf cfg.bundle.${name}.enable config);
    }) (libx.filesIn bundlesDir);

  # ========================== Buildables ========================== #

  mkNixOsConf =
    config:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          nixpkgs
          home-manager
          libx
          ;
        inherit (inputs) self;
        dotfilesPath = inputs.self + /dotfiles;
      };
      modules = [
        config
        inputs.noctalia.nixosModules.default
        outputs.nixosModules.default
      ];
    };

  mkNixOsConfs =
    dir: builtins.mapAttrs (host: _: libx.mkNixOsConf (dir + "/${host}")) (dirsCleanIn dir);

  mkNixOsUserConf = user: config: {
    imports = [
      inputs.nix-index-database.homeModules.nix-index
      inputs.caelestia-shell.homeManagerModules.default
      inputs.niri.homeModules.niri
      inputs.noctalia.homeModules.default
      inputs.vicinae.homeManagerModules.default
      outputs.homeManagerModules.default
      outputs.homeManagerModules.linux
    ];
    config = config;
  };

  mkNixDarwinConf =
    config:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          nixpkgs
          home-manager
          libx
          ;
        inherit (inputs) self;
        dotfilesPath = inputs.self + /dotfiles;
      };
      modules = [
        config
        outputs.nixDarwinModules.default
      ];
    };

  mkNixDarwinConfs =
    dir:
    builtins.listToAttrs (
      builtins.map (host: {
        name = libx.fileNameOf host;
        value = libx.mkNixDarwinConf host;
      }) (filesIn dir)
    );

  # ========================== Extenders =========================== #

  # Evaluates nixos/home-manager module and extends it's options / config
  extendModule =
    { path, ... }@args:
    { pkgs, ... }@margs:
    let
      eval = if (builtins.isString path) || (builtins.isPath path) then import path margs else path margs;
      evalNoImports = builtins.removeAttrs eval [
        "imports"
        "options"
      ];

      extra =
        if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args) then
          [
            (
              { ... }:
              {
                options = args.extraOptions or { };
                config = args.extraConfig or { };
              }
            )
          ]
        else
          [ ];
    in
    {
      imports = (eval.imports or [ ]) ++ extra;

      options =
        if builtins.hasAttr "optionsExtension" args then
          (args.optionsExtension (eval.options or { }))
        else
          (eval.options or { });

      config =
        if builtins.hasAttr "configExtension" args then
          (args.configExtension (eval.config or evalNoImports))
        else
          (eval.config or evalNoImports);
    };

  # Applies extendModules to all modules
  # modules can be defined in the same way
  # as regular imports, or taken from "filesIn"
  extendModules =
    extension: modules:
    map (
      f:
      let
        name = fileNameOf f;
      in
      (extendModule ((extension name) // { path = f; }))
    ) modules;
}

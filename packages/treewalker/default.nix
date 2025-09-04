{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "treewalker";
  version = "5a244f639fac42b652da4194d3b8a9525c1861dc";

  src = fetchFromGitLab {
    owner = "makapuf";
    repo = "treewalker";
    rev = "${version}";
    hash = "sha256-RyeM9AniUhJtjfNmXZnZm7opCVJXihqBEhh5QvC8yHo=";
  };

  cargoHash = "sha256-D+T3vp4pmbS/UOqZf/q4zrPKRVuvF3pQR/2tQ3uc0ik=";

  meta = with lib; {
    description = "A Rust binary crate for tree walking operations";
    homepage = "https://gitlab.com/makapuf/treewalker";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.maari ];
    mainProgram = "treewalker";
  };
}

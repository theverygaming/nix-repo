{
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  graphviz,
  dataclasses-json,
}:

buildPythonApplication {
  pname = "cutekit";
  version = "nightly";
  pyproject = true;

  build-system = [
    setuptools
  ];

  src = fetchFromGitHub {
    owner = "cute-engineering";
    repo = "cutekit";
    rev = "14bdecb5585b6f476a956a6c8a19a4a84573791e";
    sha256 = "sha256-BVsEOd02k9jaqFz1W+089V9VVe1jMYsf2avIz8qNvpM=";
  };

  patches = [
    ./nixos-support.patch
    ./requirements.patch
  ];

  propagatedBuildInputs = [
    graphviz
    dataclasses-json
  ];
}

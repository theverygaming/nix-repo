{
  buildCutekitPackage,
  fetchFromGitHub,
  llvmPackages_20,
  liburing,
  libseccomp,
}:

let
  llvm20buildCutekitPackage = (
    buildCutekitPackage.override {
      llvmPackages = llvmPackages_20;
    }
  );
in
llvm20buildCutekitPackage (finalAttrs: {
  pname = "paper-muncher";
  version = "nightly";

  src = fetchFromGitHub {
    owner = "odoo";
    repo = "paper-muncher";
    rev = "06f403d4184872f8154ef8ba29fe449d24d13ab6";
    sha256 = "sha256-TeTULFodFR9mPj1iPNNicHHxfInKjCYFtkSHJtUf0ao=";
  };

  ckComponent = "paper-muncher";
  ckDepsHash = "sha256-PezRsHFUOmZs+36Se1v1alzX+nqixfHf1jl9a59rj4I=";

  buildInputs = [
    liburing
    libseccomp
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    TMPDIR=$(mktemp -d)

    cat << EOF > $TMPDIR/test.html
    <!DOCTYPE html>
    <html>
    <head>
    <title>meow</title>
    </head>
    <body>
    <h1>meeeow</h1>
    <p>maaaow mrrp :3</p>
    </body>
    </html>
    EOF

    $out/bin/paper-muncher $TMPDIR/test.html -o $TMPDIR/test.pdf
    grep "Powered By Karm PDF" $TMPDIR/test.pdf

    runHook postInstallCheck
  '';
})

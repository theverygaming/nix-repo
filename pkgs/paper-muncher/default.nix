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
    rev = "18cb59da95ccbac81daf9c9bdfd08365cf4e4763";
    sha256 = "sha256-orLlyyLWwKpWk87MjHg11Hjxp87C1BqhiBxz9mHZuHc=";
  };

  ckComponent = "paper-muncher";
  ckDepsHash = ""; # FIXME: this fixed output aint so fixed rn unfortunately :broken_heart:

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

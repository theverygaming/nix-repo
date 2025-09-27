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
    rev = "a336659ca32919cea6b410f9b2aab9862b58bbe2";
    sha256 = "sha256-eiSm2OfuVc6Y3nuMae+HoyobgzD0XNwcql48fPWeaUI=";
  };

  ckComponent = "paper-muncher";
  ckDepsHash = "sha256-FlorkF2MXkRgrxwfSWLQq6tGBw+JV/lAV3aOpI0Wwf8=";

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

    $out/bin/paper-muncher --unsecure print $TMPDIR/test.html -o $TMPDIR/test.pdf
    grep "Powered By Karm PDF" $TMPDIR/test.pdf

    runHook postInstallCheck
  '';
})

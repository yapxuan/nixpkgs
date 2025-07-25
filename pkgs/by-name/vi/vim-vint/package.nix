{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "vim-vint";
  version = "0.3.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Vimjas";
    repo = "vint";
    tag = "v${version}";
    hash = "sha256-A0yXDkB/b9kEEXSoLeqVdmdm4p2PYL2QHqbF4FgAn30=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    ansicolor
    chardet
    pyyaml
    setuptools # pkg_resources is imported during runtime
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
  ];

  preCheck = ''
    substituteInPlace \
      test/acceptance/test_cli.py \
      test/acceptance/test_cli_vital.py \
      --replace-fail \
        "cmd = ['bin/vint'" \
        "cmd = ['$out/bin/vint'"
  '';

  meta = with lib; {
    description = "Fast and Highly Extensible Vim script Language Lint implemented by Python";
    homepage = "https://github.com/Kuniwak/vint";
    license = licenses.mit;
    mainProgram = "vint";
    maintainers = [ ];
    platforms = platforms.all;
  };
}

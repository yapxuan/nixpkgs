{
  lib,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  passlib,
  python-dateutil,
  pythonOlder,
  scramp,
  hatchling,
  versioningit,
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.31.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HqRs8J2Oygf+fqre/XlR43vuf6vmdd8WTxpXL/swCHY=";
  };

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [
    passlib
    python-dateutil
    scramp
  ]
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Tests require a running PostgreSQL instance
  doCheck = false;

  pythonImportsCheck = [ "pg8000" ];

  meta = with lib; {
    description = "Python driver for PostgreSQL";
    homepage = "https://github.com/tlocke/pg8000";
    changelog = "https://github.com/tlocke/pg8000#release-notes";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}

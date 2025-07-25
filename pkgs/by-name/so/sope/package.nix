{
  lib,
  clangStdenv,
  fetchFromGitHub,
  libxml2,
  openssl,
  openldap,
  mariadb,
  libmysqlclient,
  libpq,
  gnustep-make,
  gnustep-base,
}:

clangStdenv.mkDerivation rec {
  pname = "sope";
  version = "5.12.2";

  src = fetchFromGitHub {
    owner = "Alinto";
    repo = "sope";
    rev = "SOPE-${version}";
    hash = "sha256-GeJ1o8Juw7jm3/pkfuMqVpfMxKewU6hQmBoPmb0HgTc=";
  };

  buildInputs = [
    gnustep-base
    libxml2
    openssl
  ]
  ++ lib.optional (openldap != null) openldap
  ++ lib.optionals (mariadb != null) [
    libmysqlclient
    mariadb
  ]
  ++ lib.optional (libpq != null) libpq;

  # Configure directories where files are installed to. Everything is automatically
  # put into $out (thanks GNUstep) apart from the makefiles location which is where
  # makefiles are read from during build but also where the SOPE makefiles are
  # installed to in the install phase. We move them over after the installation.
  preConfigure = ''
    mkdir -p /build/Makefiles
    ln -s ${gnustep-make}/share/GNUstep/Makefiles/* /build/Makefiles
    cat <<EOF > /build/GNUstep.conf
    GNUSTEP_MAKEFILES=/build/Makefiles
    EOF
  '';

  configureFlags = [
    "--prefix="
    "--disable-debug"
    "--enable-xml"
    "--with-ssl=ssl"
  ]
  ++ lib.optional (openldap != null) "--enable-openldap"
  ++ lib.optional (mariadb != null) "--enable-mysql"
  ++ lib.optional (libpq != null) "--enable-postgresql";

  env = {
    GNUSTEP_CONFIG_FILE = "/build/GNUstep.conf";
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types -Wno-error=int-conversion";
  };

  # Move over the makefiles (see comment over preConfigure)
  postInstall = ''
    mkdir -p $out/share/GNUstep/Makefiles
    find /build/Makefiles -mindepth 1 -maxdepth 1 -not -type l -exec cp -r '{}' $out/share/GNUstep/Makefiles \;
  '';

  meta = {
    description = "Extensive set of frameworks which form a complete Web application server environment";
    license = lib.licenses.publicDomain;
    homepage = "https://github.com/inverse-inc/sope";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jceb ];
    knownVulnerabilities = [ "CVE-2025-53603" ];
  };
}

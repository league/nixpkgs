{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, m4, yacc }:

let
  openbsd_version =
    "OPENBSD_6_8"; # This has to be equal to ${src}/OPENBSD_BRANCH
  openbsd = fetchFromGitHub {
    name = "portable";
    owner = "openbgpd-portable";
    repo = "openbgpd-openbsd";
    rev = openbsd_version;
    sha256 = "sha256-vCVK5k4g6aW2z2fg7Kv0uvkX7f34aRc8K2myb3jjl6w=";
  };
in stdenv.mkDerivation rec {
  pname = "opengpd";
  version = "6.8p0";

  src = fetchFromGitHub {
    owner = "openbgpd-portable";
    repo = "openbgpd-portable";
    rev = version;
    sha256 = "sha256-TKs6tt/SCWes6kYAGIrSShZgOLf7xKh26xG3Zk7wCCw=";
  };

  nativeBuildInputs = [ autoconf automake libtool m4 yacc ];

  preConfigure = ''
    mkdir ./openbsd
    cp -r ${openbsd}/* ./openbsd/
    chmod -R +w ./openbsd
    openbsd_version=$(cat ./OPENBSD_BRANCH)
    if [ "$openbsd_version" != "${openbsd_version}" ]; then
      echo "OPENBSD VERSION does not match"
      exit 1
    fi
    ./autogen.sh
  '';

  meta = with lib; {
    description =
      "A free implementation of the Border Gateway Protocol, Version 4. It allows ordinary machines to be used as routers exchanging routes with other systems speaking the BGP protocol";
    license = licenses.isc;
    homepage = "http://www.openbgpd.org/";
    maintainers = with maintainers; [ kloenk ];
    platforms = platforms.linux;
  };
}

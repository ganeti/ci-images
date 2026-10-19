#!/bin/bash

set -eu

# set PYTEST
case ${RELEASE} in
	16.0)
		PYTEST="pytest-3.13"
		;;
	15.6)
		PYTEST="pytest-3.6"
		ZYPPER_INSTALL_OPTS="--force-resolution"
		;;
esac

# extras
case ${RELEASE} in
        # new distros with >=python-3.12 and hlint
	16.0)
		EXTRA="python3-pyasyncore hlint"
		;;
esac

cat << EODF
FROM docker.io/opensuse/leap:${RELEASE}

RUN zypper --non-interactive  addrepo --refresh obs://home:ganeti/${RELEASE} home:ganeti
RUN zypper --non-interactive --gpg-auto-import-keys refresh && zypper --non-interactive update --no-confirm
RUN zypper --non-interactive install --no-confirm --no-recommends ${ZYPPER_INSTALL_OPTS:-} \\
  autoconf \\
  automake \\
  cabal-install \\
  fakeroot \\
  findutils \\
  git \\
  ghc \\
  ghc-attoparsec-devel \\
  ghc-base64-bytestring-devel \\
  ghc-cryptonite-devel \\
  ghc-curl-devel \\
  ghc-hinotify-devel \\
  ghc-hslogger-devel \\
  ghc-json-devel \\
  ghc-lens-devel \\
  ghc-lifted-base-devel \\
  ghc-network-devel \\
  ghc-old-time-devel \\
  ghc-PSQueue-devel \\
  ghc-QuickCheck-devel \\
  ghc-regex-tdfa-devel \\
  ghc-snap-server-devel \\
  ghc-temporary-devel \\
  ghc-test-framework-hunit-devel \\
  ghc-test-framework-quickcheck2-devel \\
  ghc-utf8-string-devel \\
  ghc-vector-devel \\
  ghc-zlib-devel \\
  graphviz \\
  graphviz-gd \\
  graphviz-gnome \\
  hscolour \\
  iproute2 \\
  make \\
  man \\
  openssh-clients \\
  pandoc \\
  python3-base \\
  python3-bitarray \\
  python3-coverage \\
  python3-docutils \\
  python3-paramiko \\
  python3-psutil \\
  python3-pycodestyle \\
  python3-pycurl \\
  python3-pyinotify \\
  python3-pylint \\
  python3-pyOpenSSL \\
  python3-pyparsing \\
  python3-pytest \\
  python3-PyYAML \\
  python3-Sphinx \\
  qemu-img \\
  shelltestrunner \\
  socat ${EXTRA:-} && zypper --non-interactive clean --all

# uh, configure should hanlde this
RUN ln -s /usr/bin/${PYTEST} /usr/bin/pytest-3

RUN groupadd -r build && useradd -r -g build build
EODF

#!/bin/bash

VER_ORIG=$1
VER=$2
RELEASE=1c-enterprise83
PATH=../linuxbuh/app-office/$RELEASE
PATH_CLIENT=-client
PATH_CLIENT_NLS=-client-nls
PATH_COMMON=-common
PATH_COMMON_NLS=-common-nls
#PATH_CRS=-crs
PATH_SERVER=-server
PATH_SERVER_NLS=-server-nls
PATH_THIN_CLIENT=-thin-client
PATH_THIN_CLIENT_NLS=-thin-client-nls
PATH_WS=-ws
PATH_WS_NLS=-ws-nls

/bin/cp -p -f $PATH$PATH_CLIENT/$RELEASE$PATH_CLIENT-8.3.$VER_ORIG.ebuild $PATH$PATH_CLIENT/$RELEASE$PATH_CLIENT-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_CLIENT_NLS/$RELEASE$PATH_CLIENT_NLS-8.3.$VER_ORIG.ebuild $PATH$PATH_CLIENT_NLS/$RELEASE$PATH_CLIENT_NLS-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_COMMON/$RELEASE$PATH_COMMON-8.3.$VER_ORIG.ebuild $PATH$PATH_COMMON/$RELEASE$PATH_COMMON-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_COMMON_NLS/$RELEASE$PATH_COMMON_NLS-8.3.$VER_ORIG.ebuild $PATH$PATH_COMMON_NLS/$RELEASE$PATH_COMMON_NLS-8.3.$VER.ebuild
#/bin/cp -p -f $PATH$PATH_CRS/$RELEASE$PATH_CRS-8.3.$VER_ORIG.ebuild $PATH$PATH_CRS/$RELEASE$PATH_CRS-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_SERVER/$RELEASE$PATH_SERVER-8.3.$VER_ORIG.ebuild $PATH$PATH_SERVER/$RELEASE$PATH_SERVER-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_SERVER_NLS/$RELEASE$PATH_SERVER_NLS-8.3.$VER_ORIG.ebuild $PATH$PATH_SERVER_NLS/$RELEASE$PATH_SERVER_NLS-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_THIN_CLIENT/$RELEASE$PATH_THIN_CLIENT-8.3.$VER_ORIG.ebuild $PATH$PATH_THIN_CLIENT/$RELEASE$PATH_THIN_CLIENT-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_THIN_CLIENT_NLS/$RELEASE$PATH_THIN_CLIENT_NLS-8.3.$VER_ORIG.ebuild $PATH$PATH_THIN_CLIENT_NLS/$RELEASE$PATH_THIN_CLIENT_NLS-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_WS/$RELEASE$PATH_WS-8.3.$VER_ORIG.ebuild $PATH$PATH_WS/$RELEASE$PATH_WS-8.3.$VER.ebuild
/bin/cp -p -f $PATH$PATH_WS_NLS/$RELEASE$PATH_WS_NLS-8.3.$VER_ORIG.ebuild $PATH$PATH_WS_NLS/$RELEASE$PATH_WS_NLS-8.3.$VER.ebuild

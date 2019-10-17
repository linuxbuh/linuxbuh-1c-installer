#!/bin/bash

VER=$1
RELEASE=1c-enterprise83
PATH=../linuxbuh/app-office
PATH_CLIENT=-client
PATH_CLIENT_NLS=-client-nls
PATH_COMMON=-common
PATH_COMMON_NLS=-common-nls
PATH_CRS=-crs
PATH_SERVER=-server
PATH_SERVER_NLS=-server-nls
PATH_THIN_CLIENT=-thin-client
PATH_THIN_CLIENT_NLS=-thin-client-nls
PATH_WS=-ws
PATH_WS_NLS=-ws-nls

ebuildd=/usr/lib/python-exec/python3.6/ebuild

cd $PATH

$ebuildd $RELEASE$PATH_CLIENT-$VER.ebuild manifest
#$ebuildd $PATH$PATH_CLIENT_NLS/$RELEASE$PATH_CLIENT_NLS-$VER.ebuild manifest
#$ebuildd $PATH$PATH_COMMON/$RELEASE$PATH_COMMON-$VER.ebuild manifest
#$ebuildd $PATH$PATH_COMMON_NLS/$RELEASE$PATH_COMMON_NLS-$VER.ebuild manifest
#$ebuildd $PATH$PATH_CRS/$RELEASE$PATH_CRS-$VER.ebuild manifest
#$ebuildd $PATH$PATH_SERVER/$RELEASE$PATH_SERVER-$VER.ebuild manifest
#$ebuildd $PATH$PATH_SERVER_NLS/$RELEASE$PATH_SERVER_NLS-$VER.ebuild manifest
#$ebuildd $PATH$PATH_THIN_CLIENT/$RELEASE$PATH_THIN_CLIENT-$VER.ebuild manifest
#$ebuildd $PATH$PATH_THIN_CLIENT_NLS/$RELEASE$PATH_THIN_CLIENT_NLS-$VER.ebuild manifest
#$ebuildd $PATH$PATH_WS/$RELEASE$PATH_WS-$VER.ebuild manifest
#$ebuildd $PATH$PATH_WS_NLS/$RELEASE$PATH_WS_NLS-$VER.ebuild manifest

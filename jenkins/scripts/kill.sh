#!/usr/bin/env sh

#kill $(cat .pidfile)
kill $(cat .pidfile) 2>/dev/null || true
rm -f .pidfile
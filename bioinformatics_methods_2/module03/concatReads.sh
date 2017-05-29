#!/usr/bin/sh
# Clint Valentine
# 10/13/2016

echo "Concatenating Left Pairs..."
cat *.p.left.fq > trimmed.left.fq
echo "Concatenating Right Pairs..."
cat *.p.right.fq > trimmed.right.fq

echo -n "Lines: "
wc -l trimmed.left.fq
echo -n "Lines: "
wc -l trimmed.right.fq

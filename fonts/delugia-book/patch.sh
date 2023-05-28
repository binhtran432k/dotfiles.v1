#!/usr/bin/bash

for i in *Italic.ttf; do
	pyftfeatfreeze -f 'calt,ss01' $i $i
done

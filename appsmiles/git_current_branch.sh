#!/bin/sh

function _branch() { git rev-parse --abbrev-ref HEAD; }
_branch;

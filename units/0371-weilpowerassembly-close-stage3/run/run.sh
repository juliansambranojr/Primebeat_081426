#!/bin/sh
cd "$(dirname "$0")/../../../lean_stage3"
lake build Stage3.WeilPowerAssembly

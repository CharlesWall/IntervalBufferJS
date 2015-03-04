#!/bin/bash
mocha --compilers coffee:coffee-script/register -R spec --timeout 30000 $@
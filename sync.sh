#! /usr/bin/bash

included_paths=$(cat included | tr '\n' ' ')

cp -r $included_paths .


#! /usr/bin/bash

included_paths=$(tr < included '\n' ' ')

cp -r "$included_paths" .


#! /usr/bin/bash

included=$(cat included)

search_phrase=$(cat included | tr "\n" "|" | rev | cut -c2- | rev)

search_phrase="($search_phrase)"

included_directories=$(ls -d ~/user-configs/* | egrep $search_phrase)

cp -r $included_directories .

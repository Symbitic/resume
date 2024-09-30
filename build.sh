#!/bin/bash

declare -a Projects=(
    # "csv2table"
    "SqlTest"
    "computestream"
    #"spotifyxr"
    #"standard-release"
    "9-11"
    #"simpleble"
    "litexa-ts"
)

PROJECTS=""
PROJECTS_FILE=$(mktemp)
YAML_FILE=$(mktemp)
REGEX="# @PROJECTS@"

for name in ${Projects[@]}
do
    str=$(sed 's/^/  /g' projects/${name}.yml)
    PROJECTS="${PROJECTS}${str}\n"
done

echo -e "$PROJECTS" > "$PROJECTS_FILE"

sed -e "/$REGEX/r $PROJECTS_FILE" alex.yml > "$YAML_FILE"

if [ -e "./pandoc" ]
then
    PANDOC="${PWD}/pandoc"
else
    PANDOC=$(which pandoc)
fi

${PANDOC} --template resume.pandoc.tex --pdf-engine=lualatex -o resume.pdf -f markdown "$YAML_FILE"

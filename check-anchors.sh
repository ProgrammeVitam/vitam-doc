#!/bin/bash
cd "$(dirname "$0")"

if [ ! -d "build/html/" ]; then
  echo "You must generate the HTML documentation before running this script."
  exit 1
fi

function exists_in_list() {
  VALUE=$1
  LIST=$2
  for x in $LIST; do
    if [ "$x" = "$VALUE" ]; then
      return 0
    fi
  done
  return 1
}

echo "Choose which branch to analyse (if you don't see your branch, make sure you generated the HTML documentation before running this script and that your branch is listed in conf.py file):"
select branch in $(ls build/html ); do
  for f in $(find "build/html/$branch" -name "*.html"); do
    ids=$(grep -Po "(?<=id=[\"'])([^\"']*)(?=[\"'])" -R "$f")
    hrefs=$(grep -Po "(?<=href=[\"']#)([^\"']*)(?=[\"'])" -R "$f")

    errors=""
    for href in $hrefs; do
      if ! exists_in_list "$href" "$ids"; then
        errors="${errors}$(echo -e "\t- #$href")\n"
      fi
    done

    if [ -n "$errors" ]; then
      echo "- $f"
      echo -e "$errors"
    fi
  done
  break
done

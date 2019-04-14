#!/usr/bin/env bash

set -eo pipefail
shopt -s dotglob

# make sure we can GTFO
trap 'echo >&2 Ctrl+C captured, exiting; exit 1' SIGINT

usage() {
  self="$(basename "$0")"
	cat <<-EOUSAGE
		usage: $self repo[:tag] repo:tag [prefix count]
		   ie: $self build:travis metowolf/php:7.3.4
		       $self build metowolf/php:7.3.4 2
	EOUSAGE
}

if [ $# -lt 2 ]; then
	usage >&2
	exit 1
fi

image_build="$1" && shift
image_target="$1" && shift
prefix_count=${1:-"0"}

target_name=`echo "$image_target" | cut -d: -f1`
target_version=`echo "$image_target" | cut -d: -f2`
target_version_count=`echo "$target_version" | tr -dc '.' | wc -c | awk '{$1=$1;print}'`

versions=()

if [[ "$target_version" =~ -dev$ ]]; then
  is_dev="true"
  target_version=`echo $target_version | sed 's/-dev$//'`
fi

if [[ "$prefix_count" = "0" ]]; then
  if [ ! -z $is_dev ]; then
    versions+=("dev")
  else
    versions+=("latest")
  fi
  prefix_count="1"
fi

for (( i=$((${target_version_count}+1)); i>=${prefix_count}; i-- )); do
  version=`echo "$target_version" | cut -d. -f1-${i}`
  if [ ! -z $is_dev ]; then
    version="$version-dev"
  fi
  versions+=($version)
done

for version in "${versions[@]}"; do
  docker tag ${image_build} ${target_name}:${version}
  docker push ${target_name}:${version}
done

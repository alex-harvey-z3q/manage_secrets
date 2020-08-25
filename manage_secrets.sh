#!/usr/bin/env bash

OPTIONS="hlgcrud"

usage() {
  echo "Usage: [SECRET_NAME=secret_name] \
[SECRET_DESC='secret desc'] [SECRET=xxxx] bash $0 [-$OPTIONS]"
  echo "Lists, creates, updates, rotates, or deletes a secret."
  exit 1
}

get_opts() {
  command=(aws secretsmanager)

  while getopts "$OPTIONS" opt ; do
    case $opt in
      h) usage ;;
      l) command+=(list-secrets     --query      'SecretList[].Name') ;;
      g) command+=(get-secret-value --secret-id  "$SECRET_NAME") ;;
      c) command+=(create-secret    --name       "$SECRET_NAME") ;;
      r) command+=(rotate-secret    --secret-id  "$SECRET_NAME") ;;
      u) command+=(update-secret    --secret-id  "$SECRET_NAME") ;;
      d) command+=(delete-secret    --secret-id  "$SECRET_NAME") ;;

      \?) echo "ERROR: Invalid option -$OPTARG"
        usage ;;
    esac
  done
  shift $((OPTIND-1))
}

post_process_opts() {
  if [ "${#command[@]}" -eq 2 ] ; then
    command+=(list-secrets --query 'SecretList[].Name')
  fi

  grep -q "list-secrets" <<< "${command[@]}" && return

  if grep -q "get-secret-value" <<< "${command[@]}" ; then
    [ ! -z "$SECRET" ] && usage
    [ ! -z "$SECRET_DESC" ] && usage
    command+=(--query 'SecretString' --output 'text')
  fi

  if [ ! -z "$SECRET_DESC" ] ; then
    command+=(--description "$SECRET_DESC")
  fi

  [ -z "$SECRET_NAME" ] && usage

  if [ ! -z "$SECRET" ] ; then
    command+=(--secret-string "$SECRET")
  fi
}

manage_secret() { "${command[@]}" ; }

main() {
  get_opts "$@"
  post_process_opts
  manage_secret
}

if [ "$0" == "${BASH_SOURCE[0]}" ] ; then
  main "$@"
fi

# vim: set ft=sh:

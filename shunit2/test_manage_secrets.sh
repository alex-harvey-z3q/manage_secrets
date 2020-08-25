#!/usr/bin/env

under_test='./manage_secrets.sh'

setUp() { . "$under_test" ; }

tearDown() { unset OPTIND ; }

aws() { : ; }

test_no_args_defaults_to_l() {
  main
  assertEquals "aws secretsmanager list-secrets --query \
SecretList[].Name" "${command[*]}"
}

test_list_secrets() {
  main -l
  assertEquals "aws secretsmanager list-secrets --query \
SecretList[].Name" "${command[*]}"
}

test_no_secret_name() {
  (main -g) | grep -i usage
  assertTrue "$?"
  (main -c) | grep -i usage
  assertTrue "$?"
  (main -r) | grep -i usage
  assertTrue "$?"
  (main -u) | grep -i usage
  assertTrue "$?"
  (main -d) | grep -i usage
  assertTrue "$?"
}

test_get_secret() {
  SECRET_NAME='foo' main -g
  assertEquals "aws secretsmanager get-secret-value \
--secret-id foo --query SecretString --output text" "${command[*]}"
}

test_get_secret_unwanted_desc_passed() {
  (SECRET_NAME='foo' SECRET_DESC='my desc' main -g) | grep -i usage
  assertTrue "$?"
}

test_get_secret_unwanted_secret_passed() {
  (SECRET_NAME='foo' SECRET='xxx' main -g) | grep -i usage
  assertTrue "$?"
}

test_create_secret_name_only() {
  SECRET_NAME='foo' main -c
  assertEquals "aws secretsmanager \
create-secret --name foo" "${command[*]}"
}

test_create_with_desc() {
  SECRET_NAME='foo' SECRET_DESC='my desc' main -c
  assertEquals "aws secretsmanager create-secret \
--name foo --description my desc" "${command[*]}"
}

test_create_and_secret() {
  SECRET_NAME='foo' SECRET='xxx' main -c
  assertEquals "aws secretsmanager create-secret \
--name foo --secret-string xxx" "${command[*]}"
}

test_create_with_desc_and_secret() {
  SECRET_NAME='foo' SECRET_DESC='my desc' SECRET='xxx' main -c
  assertEquals "aws secretsmanager create-secret \
--name foo --description my desc --secret-string xxx" "${command[*]}"
}

test_rotate_secret_name_only() {
  SECRET_NAME='foo' main -r
  assertEquals "aws secretsmanager \
rotate-secret --secret-id foo" "${command[*]}"
}

test_delete_secret_name_only() {
  SECRET_NAME='foo' main -d
  assertEquals "aws secretsmanager \
delete-secret --secret-id foo" "${command[*]}"
}

test_update_secret_name_only() {
  SECRET_NAME='foo' main -u
  assertEquals "aws secretsmanager \
update-secret --secret-id foo" "${command[*]}"
}

test_update_secret_name_and_secret() {
  SECRET_NAME='foo' SECRET='xxx' main -u
  assertEquals "aws secretsmanager update-secret --secret-id foo \
--secret-string xxx" "${command[*]}"
}

. shunit2

# manage_secrets.sh

## Overview

This is a shell script wrapper for AWS Secrets Manager, exposing commonly-needed options in an easy-to-use interface.

## Installation

To install, just download the script:

```text
▶ curl \
  https://raw.githubusercontent.com/alexharv074/manage_secrets/master/manage_secrets.sh \
    -o /usr/local/bin/manage_secrets.sh
```

## Usage

### Help message

```text
▶ manage_secrets.sh -h
Usage: [SECRET_NAME=secret_name] [SECRET_DESC='secret desc'] [SECRET=xxxx] manage_secrets.sh [-hlgcrud]
Lists, creates, updates, rotates, or deletes a secret.
```

### List secrets

```text
▶ manage_secrets.sh -l
[
    "bar",
    "baz"
]
```

### Create a secret

```text
▶ SECRET_DESC='my secret' SECRET_NAME='foo' SECRET='xxx' manage_secrets.sh -c
{
    "ARN": "arn:aws:secretsmanager:ap-southeast-2:901798091585:secret:foo-qs8nQ3",
    "Name": "foo",
    "VersionId": "f1d7b305-5a75-4b75-a07a-da08a0991715"
}
```

### Update a secret

```text
▶ SECRET_NAME='foo' SECRET='yyy' manage_secrets.sh -u
```

### Get a secret value

```text
▶ SECRET_NAME='foo' manage_secrets.sh -g
yyy
```

### Rotate a secret

This presumes you have set up the [rotation](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html) Lambda.

```text
▶ SECRET_NAME='foo' manage_secrets.sh -r
```

### Delete a secret

```text
▶ SECRET_NAME='foo' manage_secrets.sh -d
```

## License

MIT.

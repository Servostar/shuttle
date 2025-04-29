
<img alt="banner" width="100%" src="./assets/banner.svg">

<div align="center">
  <h2>
      Portable shell script library
  </h2>
</div>

<div align="center">
    <img src="https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white">
    <img src="https://img.shields.io/github/license/servostar/shuttle?style=for-the-badge">
    <img src="https://img.shields.io/github/actions/workflow/status/servostar/shuttle/checks.yml?style=for-the-badge">
</div>

## Features

- Compliance to POSIX.1-2024
- Escape codes for styling as defined by ECMA-48
- Logging interface (with colors!)

## Table of Contents

1. [Features](#features)
2. [References](#references)
3. [Get](#get)
4. [Tests](#tests)

## Get

For a quick start you can download the latest release [here](https://github.com/Servostar/shuttle/releases).
In order to use shuttle source it in your script.
Or use the direct, quick and dirty way:

```
VERSION="v0.1.1"
. <(curl -fsSL https://github.com/Servostar/shuttle/releases/download/$VERSION/shuttle-$VERSION.min.sh)
```

> It's best to download the script locally in order not to run random scripts
> from the internet!

## Tests

Tests are written in Shellspec, a behavior driven testing framework.
Files can be found in `spec` and are written in a domain specific language.
You can run tests by running Shellspec in the root of the repository:

```
shellspec
```

## References

Standards used to write shuttle.sh and reference for implementation.
Take a look at the Open Group base specification for IEEE Std 1003.1-2017
and ECMA International.

-  The Open Group Base Specifications Issue 8; 2024; The Open Group; Available at: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
- ECMA-48; "Control functions for coded character sets"; 1991; ECMA International; Available at: https://ecma-international.org/publications-and-standards/standards/ecma-48/
- IEEE Std 1003.1-2017; "IEEE Standard for Information Technology--Portable Operating System Interface (POSIX(TM)) Base Specifications, Issue 7"; 2018; IEEE; Available at: https://ieeexplore.ieee.org/document/8277153

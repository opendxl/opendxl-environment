[![Actions Status](https://github.com/opendxl/opendxl-environment/workflows/Build/badge.svg)](https://github.com/opendxl/opendxl-environment/actions)
[![Docker Build Status](https://img.shields.io/docker/build/opendxl/opendxl-environment.svg)](https://hub.docker.com/r/opendxl/opendxl-environment/)

# OpenDXL Environment

## Overview

The OpenDXL Environment is a pre-configured environment available as a [Docker](https://www.docker.com/) image that supports the development and running of OpenDXL solutions. 

The OpenDXL Environment is based on the [Debian operating system](https://www.debian.org/) and includes standard tools and libraries that are commonly used to develop and run OpenDXL solutions. The environment also includes a [web front-end](https://github.com/opendxl/opendxl-environment/wiki/Console-Overview) based on [Cloud Commander](http://cloudcmd.io/) that supports browser-based file management, file editing, and terminal access.

The environment supports:
* Python (2 and 3)
  * The default `python` and `pip` executables are Python 2. The `python3` and `pip3` executables are Python 3.
* Java (JDK 1.8)
* Node.js (Node 6)

The goal of the OpenDXL Environment is to provide a consistent way to develop OpenDXL solutions across platforms and eliminate the need to manually install commonly used tools (git, wget, curl, etc.) and libraries ([OpenDXL Python Client](https://github.com/opendxl/opendxl-client-python), [OpenDXL Bootstrap](https://github.com/opendxl/opendxl-bootstrap-python)).

The OpenDXL Environment Docker image is available at the following location within [Docker Hub](https://hub.docker.com):

[https://hub.docker.com/r/opendxl/opendxl-environment/](https://hub.docker.com/r/opendxl/opendxl-environment/)

## Documentation

See the [Wiki](https://github.com/opendxl/opendxl-environment/wiki) for installation, configuration, usage instructions, and tutorials for the OpenDXL Environment.

## Bugs and Feedback

For bugs, questions and discussions please use the [GitHub Issues](https://github.com/opendxl/opendxl-environment/issues).

## LICENSE

Copyright 2017 McAfee, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

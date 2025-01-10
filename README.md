# US Core Test Kit

This is an [Inferno](https://inferno-framework.github.io/) test kit
for the US Core Implementation Guide
[v3.1.1](https://hl7.org/fhir/us/core/STU3.1.1/),
[v4.0.0](https://hl7.org/fhir/us/core/STU4/),
[v5.0.1](https://hl7.org/fhir/us/core/STU5.0.1/),
[v6.1.0](https://hl7.org/fhir/us/core/STU6.1/), and
[v7.0.0](https://hl7.org/fhir/us/core/STU7/).  This test kit
provides testing for US Core Servers.

Visit the [US Core Test Kit
Documentation](https://github.com/inferno-framework/us-core-test-kit/wiki) for
more information on using this test kit.

## Getting Started

The Inferno on HealthIT.gov platform hosts a [public
instance](https://inferno.healthit.gov/test-kits/us-core/) of this test
kit that developers and testers are welcome to use.  However, users are
encouraged to download and run this tool locally.

The quickest way to run this test kit locally is with [Docker](https://www.docker.com/).

- Install Docker
- Clone this repository, or download an [official release](/releases).
- Run `./setup.sh` within the test kit directory to download necessary dependencies
- Run `./run.sh` within the test kit directory to start the application
- Navigate to `http://localhost`

See the [Inferno Documentation](https://inferno-framework.github.io/docs/getting-started-users.html#running-an-existing-test-kit)
for more information on running Inferno locally.

## License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

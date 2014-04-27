fcgiwrap.rpm Cookbook
=====================
[![Build Status](https://travis-ci.org/4-20ma/cookbook-fcgiwrap.rpm.png?branch=master)](https://travis-ci.org/4-20ma/cookbook-fcgiwrap.rpm)
[![Dependency Status](https://gemnasium.com/4-20ma/cookbook-fcgiwrap.rpm.png)](https://gemnasium.com/4-20ma/cookbook-fcgiwrap.rpm)

Builds an `fcgiwrap` binary RPM. The primary use case for this cookbook is to leverage Test Kitchen to:

- create a pristine virtual machine
- download, build, & package `fcgiwrap` source code

The newly-created RPM will be located in `.rpmbuild/RPMS/x86_64/fcgiwrap-x.y.z-1.el6.x86_64.rpm`.


Requirements
------------
### Cookbooks
The following cookbooks are direct dependencies because they're used for common "default" functionality.

- [`build-essential`](https://github.com/opscode-cookbooks/build-essential)
- [`yum-epel`](https://github.com/opscode-cookbooks/yum-epel)

### Platforms
The following platform is supported and tested under Test Kitchen:

- CentosOS 6.5

Other RHEL family distributions are assumed to work.


Attributes
----------

File / Attribute(s)                 | Description
------------------------------------|------------
[default.rb](attributes/default.rb) |
`node['fcgiwrap']['packages']`      | array of packages required to build fcgiwrap
`node['fcgiwrap']['git_url']`       | URL of fcgiwrap git repo
`node['fcgiwrap']['name']`          | name to be used for RPM
`node['fcgiwrap']['version']`       | version to be used for RPM
`node['fcgiwrap']['pre_tidy']`      | set this to true to cleanup before build
`node['fcgiwrap']['post_tidy']`     | set this to true to cleanup after build


Recipes
-------
This cookbook provides one main recipe for building a binary RPM.

- `default.rb` - *Use this recipe* to build binary RPM.

### default
This recipe builds an `fcgiwrap` binary RPM.


Usage
-----
On client nodes, use the default recipe:

````javascript
{ "run_list": ["recipe[fcgiwrap.rpm]"] }
````


License & Authors
-----------------
- Author:: Doc Walker (<4-20ma@wvfans.net>)

````text
Copyright 2014, Doc Walker

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
````

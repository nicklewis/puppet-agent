The Puppet Agent
===
 * Overview
 * Runtime requirements
 * Building puppet-agent
 * Building puppet-agent for windows
 * Branches in puppet-agent
 * Installer plugin for OSX
 * License
 * Maintainers

Overview
---
The puppet agent is a collection of software that is required for puppet and
its dependencies to run. The full list of software and projects included in the
puppet agent can be found in the [project
definition](configs/projects/puppet-agent.rb). This repo is where the
puppet-agent [vanagon](http://github.com/puppetlabs/vanagon) configuration
lives. It is used to drive the building of puppet-agent packages for releases.

Runtime Requirements
---
The [Gemfile](Gemfile) specifies all of the needed ruby libraries to build a puppet-agent
package. Additionally, puppet-agent requires a VM to build within for each
desired package.

Building puppet-agent
---
If you wish to build puppet-agent yourself, it should be relatively easy. First
`bundle install`, followed by `bundle exec build puppet-agent <desired
platform> <vm hostname>`, where the platform is a platform supported by vanagon
and vm hostname is the hostname of a vm of the desired platform. The current
user must be able to ssh into that vm as root (vanagon has facilities to provide
an ssh key beyond what is listed in .ssh/config).

Building puppet-agent for windows
---
For the moment, windows is a special case. It can be built using a similar
pattern to other platforms. `ruby bin/build-windows.rb BUILD_TARGET=win-x86` is
the way to do this. The windows build assumes access to Puppet Labs' vm pooler
and does not currently accept a hostname override. VANAGON\_SSH\_KEY is
respected for ssh key overrides.

Branches in puppet-agent
---
There are two types of branches in puppet-agent
* release branches (e.g. aardwolf)
* tracking branches (e.g. master and stable)

The fundamental difference between the two is their relation with CI pipelines, especially wrt the component configurations:
* on a release branch: 
  * all components reference component tags *never* SHAs
* on a tracking branch: 
  * some components may reference tags if they’re slow moving (ruby, openssl)
  * some components reference SHAs promoted by a CI pipeline (generally puppet-agent#master pipelines track components' master branches, and likewise for stable)

Guidelines on Merging Between Branches
* stable should be merged to master regularly (e.g. per commit), as is done for component repos; no PR needed
* master should be merged to stable as-needed; typically this is done when a component merges its master to stable, and there are matching changes needed in puppet-agent
* stable should be merged to aardwolf as-needed; typically this is done when a component is tagged and ready for release, and there are matching changes needed in puppet-agent
* aardwolf should be merged to stable after each tag; this ensures that a 'git describe' on stable always refers to a "later" release than what came off aardwolf; this merge can be accomplished with 'git merge aardwolf -s ours' and should not change the contents of any files (because no content changes should ever originate on aardwolf)

Generally, no PR is needed for routine merges from stable to master or aardwolf, but a PR is advised for other merges. Use your judgment of course, and put up a PR if you want review.

Note that for all merges from master or stable, the merge should pick up:
* changes outside of config/components
* changes that bumped to a tag inside config/components

But never:
* changes that bumped to a SHA inside config/components

Here's a sample snippet used for a stable -> aardwolf merge:

```
git merge --no-commit --no-ff stable
for i in {hiera,facter,puppet,marionette-collective}; do git checkout aardwolf -- configs/components/$i.json;done
git checkout aardwolf -- configs/components/windows_*.json
git commit -m "(maint) Restore promoted components refs after merge from stable"
```

Installer plugin for OSX
---
The GUI installer for OSX includes a custom plugin that captures and sets information such
as the puppet master and certificate name for the client.  The source for this Xcode project
can be found [here](https://github.com/puppetlabs/puppet-agent-osx-installer-plugin).

License
---
Puppet agent is licensed under the [Apache-2.0](LICENSE) license.

Maintainers
---
The Release Engineering team at Puppet Labs


Slickdeals Chef Style Guide
=========================

This style guide is based off of [Julian Dunn's Style guide](https://github.com/juliandunn/chef-style-guide) yet heavily edited to work for our workflow.

Git Etiquette
-------------

Although not strictly a Chef style thing, please always ensure your ``user.name`` and ``user.email`` are set properly in your ``.gitconfig``.

By "properly", I mean that ``user.name`` is your given name (e.g., "Julian Dunn") and ``user.email`` is an actual, working e-mail address for you.

Cookbook Naming
---------------

* Avoid dashes in cookbook names. This is because any LWRPs you create will use the cookbook name as part of the LWRP name, so the methods become very awkward. In particular, since '-' can't be part of a symbol in Ruby, you won't be able to use LWRPs in any cookbooks with '-' in them.
* All wrapper cookbooks should be prefixed with a short organizational prefix and an underscore, such as 'sd_' for 'Slickdeals' (e.g. 'sd_postgresql' or 'sd_base_setupk')

Cookbook Versioning
-------------------

* Use [semantic versioning](http://semver.org/) when numbering cookbooks.
* Only upload stable cookbooks from master.
* Only upload unstable cookbooks to your own fork. Merge to master and bump the version when stable.

System and Component Naming
---------------------------

Name things uniformly for their system and component. For the ganglia master,

* attributes: `node['ganglia']['master']`
* recipe: `ganglia::master`
* role: `ganglia-master`
* directories: `ganglia/master` (if specific to component), `ganglia` (if not). For example: `/var/log/ganglia/master`

Name attributes after the recipe in which they are primarily used. e.g. `node['postgresql']['server']`

Resource Parameter Order
------------------------

Follow this order for information in each resource declaration:

*    Source
*    Cookbook
*    Resource ownership
*    Permissions
*    Notifications
*    Action

Example:

    template '/tmp/foobar.txt' do
      source 'foobar.txt.erb'
      owner  'someuser'
      group  'somegroup'
      mode   0644
      variables(
        :foo => 'bar'
      )
      notifies :reload, 'service[whatever]'
      action :create
    end

File Modes
----------

Always specify all four digits of the file mode, and not as a string.

Wrong:

    mode "644"

Right:

    mode 0644

Always Specify Action
---------------------

In each resource declarations always specify the action to be taken:

Wrong:

    package 'monit'

Right:

    package 'monit' do
      action :install
    end

FoodCritic Linting
------------------

It goes without saying that all cookbooks should pass FoodCritic rules before being uploaded.

    cookbook_directory$ foodcritic .

should return nothing.

Symbols or Strings?
-------------------

Prefer strings over symbols, because they're easier to read and you don't need to explain to non-Rubyists what a symbol is. Please retrofit old cookbooks as you come across them.

Wrong:

    default[:foo][:bar] = 'baz'

Right:

    default['foo']['bar'] = 'baz'

String Quoting
--------------

Use single-quoted strings in all situations where the string doesn't need interpolation.

Shelling Out
------------

Always use `mixlib-shellout` to shell out. Never use backticks, Process.spawn, popen4, or anything else!

As of Chef Client 12 you can use `shell_out`, `shell_out!` and `shell_out_with_system_locale` directly in recipe DSL.

Constructs to Avoid
-------------------

* `node.set` / `normal_attributes` - Avoid using attributes at normal precedence since they are set directly on the node object itself, rather than implied (computed) at runtime.
* `node.set_unless` - Can lead to weird behavior if the node object had something set. Avoid unless altogether necessary (one example where it's necessary is in `node['postgresql']['server']['password']`)
* `if node.run_list.include?('foo')` i.e. branching in recipes based on what's in the node's run list. Better and more readable to use a feature flag and set its precedence appropriately.
* `node['foo']['bar']` i.e. setting normal attributes without specifying precedence. This is deprecated in Chef 11, so either use `node.set['foo']['bar']` to replace its precedence in-place or choose the precedence to suit.
* `include Opscode::OpenSSL::Password` - Using include causes the different phases of the chef run to read this differently and can cause larger namespace clash issues. Use `::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)` and `::Chef::Resource::Nanme.send(:include, Opscode::OpenSSL::Password)` instead

Tests
-----
* Unit and Integration tests should be written for all cookbooks.
* All unit tests are written in ChefSpec/RSpec and all Test Kitchen tests are written in ServerSpec.
* All tests should be runnable using a Rakefile. This rakefile should run test:quick by default (foodcritic, rubocop, and chefspec) and there should be a test:ci that runs Test Kitchen and then test:quick.
* All `rake test:ci` tests should pass before incrementing the version number and/or pushing to master.

Templates
---------
Included with this Style Guide is a code_generator. When bootstrapping cookbooks or files you use the chef command included in ChefDK.

    chef generate XXXXX filename -g <this_repo>/code_generator

All the following should be generated with ChefDK
* cookbook
* recipe
* attribute
* lwrp

If you want to avoid having to type the ` -g <this_repo>/code_generator` every time add this to your knife.rb(s)

    chefdk[:generator_cookbook] = "#{ENV['HOME']}/Code/sd_style_guide/code_generator" if defined? ChefDK::Configurable

Rubocop
-------
Since readability is important and not everyone is a ruby programmer we use rubocop to help enforce some good style. It is not completely critical that rubocup style is met but for public cookbooks and other well treaded code should be tested.
The template generator above has our default rubocop and will install it in all new cookbooks. The default rake file too will run rubocop as part of our quick tests.
If you wish to install our default rubocop across your entire machine create the following symlink

    ln -sf $(pwd)/code_generator/files/default/rubocop.yml ~/.rubocop.yml

Having this installed for your user will augment, not overwrite cookbook specific rubocop files.

Useful Links
------------

* [Ironfan Style Guide](https://github.com/infochimps-labs/ironfan/wiki/style_guide)
* [FoodCritic](http://acrmp.github.com/foodcritic/)

License and Authors
-------------------

* Author:: Julian C. Dunn (<jdunn@aquezada.com>)
* Author:: David Aronsohn (<hipster@slickdeals.net>)
* Copyright:: 2012-2013, SecondMarket Labs, LLC.
* Copyright:: 2013-2014, Chef Software, Inc.
* Copyright:: 2015, Slickdeals, LLC.

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

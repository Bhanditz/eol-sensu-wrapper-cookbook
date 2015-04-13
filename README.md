eol-sensu-wrapper Cookbook
===========================

EOL Sensu cookbook installs and configures a Sensu server and clients to
monitor servers' state and collect statistical metrics. This cookbook requires
creation of  2 data bags **sensu** and **sensu_checks** (see description below)

Requirements
------------
- `sensu` -- Sensu cookbook provides all the resources required by
  eol-sensu-wrapper

Attributes
----------

#### eol-sensu-cookbook::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>["sensu"]["use_embedded_ruby"]</tt></td>
    <td>Boolean</td>
    <td>Sensu relies on embedded Ruby</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>["sensu"]["version"]</tt></td>
    <td>String</td>
    <td>Version of Sensu to install</td>
    <td><tt>0.16.0-1</tt></td>
  </tr>
  <tr>
    <td><tt>["uchiwa"]["version"]</tt></td>
    <td>String</td>
    <td>Version of Uchiva (Web GUI) to install</td>
    <td><tt>0.4.0-1</tt></td>
  </tr>
  <tr>
    <td><tt>["eol_sensu_wrapper"]["roles"]</tt></td>
    <td>Array</td>
    <td>Sets roles which define which checks and metrics to run</td>
    <td><tt>Empty</tt></td>
  </tr>
</table>

Included plugins
----------------

Sensu plugins either monitor some system parameters and warn about close to
critical and critical conditions for these parameters. For example
`check-disk.rb` plugin monitors percentage of disk space left on each partition
of the servers.

You can find included plugins in [files/default/plugins][1]. A comment on top
of of every plugin file explains it's purpose

Build-in "plugin"
-----------------

Keepalive is an internal Sensu service which gets signals from sensu clients
from all the machines. If server is down or sensu-slient stopped working --
server generates alert message and sends it the alerts to all keepalive
handlers. These handlers are setup differently from checks, and are described
further below.

Included handlers
-----------------

Sensu handlers allow send alerts from Sensu checks and metrics to various
communication channels -- Twitter, Email, Hipchat, Gitter etc. For example
`ponymailer.rb` handler sends alerts by email to subscribed administrators.

You can find included handlers in [files/default/handlers][2]. A comment on top
of of every handler file explains it's purpose

Usage
-----
#### eol-sensu-cookbook::default

To configure your Sensu installation decide which machine will run Sensu's
server, API, and GUI.

For this example assume the following:

* Your future Sensu server has IP 10.0.0.10
* You are interested in one check plugin `check-disk.rb`
* You are interested in one metric plugin `metric-sysopia.rb`
* You want to send alert email via `ponymailer.rb` handler

In your own cookbook:

```ruby
include_recipe "eol-sensu-wrapper"
```

Use knife to create a data bags for `sensu` and `sensu_checks`.

```bash
$ knife data bag create sensu
$ knife data bag create sensu_checks
```


Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

Authors: [Dmitry Mozzherin][1], [Jeremy Rice][2]


Copyright: 2015, [Marine Biological Laboratory][3]

Licensed under the [MIT License][4]

[1]: https://github.com/EOL/eol-sensu-wrapper-cookbook/tree/master/files/default
[1]: https://github.com/dimus
[2]: https://github.com/jrice
[3]: http://mbl.edu
[4]: https://github.com/EOL/eol-users-cookbook/blob/master/LICENSE

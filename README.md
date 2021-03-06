Portage
=======

Why
---

Portage ([1](http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=2&chap=1), [2](http://en.wikipedia.org/wiki/Portage_(software\))) is a package management software for Gentoo Linux. It stores all data in plain txt files (I know about sqlite cache)

Below are some things that I do not like in portage

* Its irritating when it takes minutes to do 'emerge -pvte world'
* There are several places where files that related to the portage work are stored.
* Dozen(s) of apps/tools are written that do quite general tasks in terms of PM

Possibly there are others..

At some moment I decided to improve my knowledge of SQL. To make this process more interesting I am trying to put portage cache and some related data into [SQLite](http://en.wikipedia.org/wiki/SQLite) database.

For now its a JFF project but if it will look solid and fast, it would be nice to have it as addition to PM in Gentoo

Requirements
-----

#### Mandatory

    Ruby 1.9 ( `>dev-lang/ruby-1.9.3` )
    SQLite 3.7.x and above ( `>dev-db/sqlite-3.7` )
    http://rubygems.org/
    http://sqlite-ruby.rubyforge.org/
    http://json-jruby.rubyforge.org/
    http://nokogiri.org/

#### Optional

    >dev-python/pysqlite-2.6
    >=app-portage/eix-0.25.5

Installation
-----------

Something like this
<pre>
git clone git://github.com/zvasyl/portage3.git /opt/portage-next
</pre>


Testing
-------

Take a look at files in *bin/examples* directory


Contributing
------------

[As usual](https://github.com/github/markup/#contributing-1)

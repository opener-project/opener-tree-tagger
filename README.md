[![Build Status](https://drone.io/github.com/opener-project/VU-tree-tagger_kernel/status.png)](https://drone.io/github.com/opener-project/VU-tree-tagger_kernel/latest)

Introduction
------------

This module implements a wrapper to process text with the PoS tagger TreeTagger. TreeTagger is a tool that assigns the lemmas and part-of-speech information to an input text. This module takes KAF as input, with the token layer created (for instance by one of our tokenizer modules) and outputs KAF with a new term layer. It is important to note that the token layer in the input is not modified in the output, so the program takes care of performing the correct matching between the term and the token layer.

The language of the input KAF text has to be specified through the attribute xml:lang in the main KAF element. This module works for text in all the languages covered by the OpeNER project (English, Dutch,German, Italian, Spanish and French). It can be easily extended to other languages by downloading the specific TreeTagger models for that language and providing a mapping from the tagset used by these models to the tagset defined in KAF. 

### Confused by some terminology?

This software is part of a larger collection of natural language processing tools known as "the OpeNER project". You can find more information about the project at [the OpeNER portal](http://opener-project.github.io). There you can also find references to terms like KAF (an XML standard to represent linguistic annotations in texts), component, cores, scenario's and pipelines.

Quick Use Example
-----------------

Installing the tree-tagger can be done by executing:

    gem install opener-tree-tagger

Also make sure you have tree-tagger and the proper language files installed AND that you set the path to the tree-tagger in the TREE_TAGGER_PATH environment variable.

Besides that, make sure you install lxml. You can probably achieve this by typing 

    pip install lxml

If that doesn't work, please check the [installation guide on the OpeNER portal](http://opener-project.github.io/getting-started/how-to/local-installation.html).

Please bare in mind that all components in OpeNER take KAF as an input and output KAF by default.

### Command line interface

You should now be able to call the tree-tagger as a regular shell command: by its name. Once installed the gem normalyl sits in your path so you can call it directly from anywhere.

This aplication reads a text from standard input in order to identify the language.

    cat some_kind_of_kaf_file.kaf | tree-tagger


This will output KAF xml.

### Webservices

You can launch a language identification webservice by executing:

    tree-tagger-server

This will launch a mini webserver with the webservice. It defaults to port 9292, so you can access it at <http://localhost:9292>.

To launch it on a different port provide the `-p [port-number]` option like this:

    tree-tagger-server -p 1234

It then launches at <http://localhost:1234>

Documentation on the Webservice is provided by surfing to the urls provided above. For more information on how to launch a webservice run the command with the ```-h``` option.


### Daemon

Last but not least the tree-tagger comes shipped with a daemon that can read jobs (and write) jobs to and from Amazon SQS queues. For more information type:

    tree-tagger-daemon -h


Description of dependencies
---------------------------

This component runs best if you run it in an environment suited for OpeNER components. You can find an installation guide and helper tools in the [OpeNER installer](https://github.com/opener-project/opener-installer) and an [installation guide on the [Opener Website](http://opener-project.github.io/getting-started/how-to/local-installation.html)

At least you need the following system setup:

### Depenencies for normal use:

* Ruby (Tested on MRI and JRuby) 1.9.3 
* Python 2.6
* LXML installed
* This module has a dependency on the following external module: TreeTagger (http://www.ims.uni-stuttgart.de/projekte/corplex/TreeTagger/) More information is further down in this document.
* Tree tagger installed and it's path know in TREE_TAGGER_PATH environment
  variable.

If TreeTagger is not installed in your machine you can download it from <http://www.ims.uni-stuttgart.de/projekte/corplex/TreeTagger/> and follow the installation instructions. To indicate to our scripts where TreeTagger is located, you have to set an environment variable with the location:

```shell
export TREE_TAGGER_PATH=/usr/local/TreeTagger/
```

It is advised you add the path to the tree tagger in your bash or zsh profile by
adding it to ```~/.bash_profile``` or ```~/.zshrc```

Language Extension
------------------

The tree-tagger depends on the availability of Tree Tagger models. Check out the tree tagger website for more languages. Also you'll have to update the py files in the core directory.

The Core
--------

The component is a fat wrapper around the actual language technology core. You can find the core technolies in the core directory of this repository.

Where to go from here
---------------------

* [Check the project website](http://opener-project.github.io)
* [Checkout the webservice](http://opener.olery.com/tree-tagger)

Report problem/Get help
-----------------------

If you encounter problems, please email support@opener-project.eu or leave an issue in the 
(issue tracker)[https://github.com/opener-project/tree-tagger/issues].


Contributing
------------

1. Fork it <http://github.com/opener-project/tree-tagger/fork>
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

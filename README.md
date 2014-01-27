# Opener::Kernel::VU::TreeTagger

VU-tree-tagger_kernel
=====================

This module implements a wrapper to process text with the PoS tagger TreeTagger. TreeTagger is a tool that assigns the lemmas and part-of-speech information to an input text.
This module takes KAF as input, with the token layer created (for instance by one of our tokenizer modules) and outputs KAF with a new term layer. It is important to note
that the token layer in the input is not modified in the output, so the program takes care of performing the correct matching between the term and the token layer.

By default this module works for text in English, Dutch and German, but can be easily extended to other languages. The language of the input KAF text has to be specified through
the attribute xml:lang in the main KAF element.

Initial version
----------------

This module has a dependency on the following external module:
TreeTagger (http://www.ims.uni-stuttgart.de/projekte/corplex/TreeTagger/)
More information is further down in this document.

Installation
------------

Add this line to your application's Gemfile:

    gem 'VU-tree-tagger_kernel', :git=>"git@github.com/opener-project/VU-tree-tagger_kernel.git"

And then execute:
````shell
$ bundle install
`````

Or install it yourself as:
````shell
$ gem specific_install VU-tree-tagger_kernel -l https://github.com/opener-project/VU-tree-tagger_kernel.git
````

If you dont have specific_install already:
````shell
    $ gem install specific_install
````

Finally you have to indicate to your program where TreeTagger is installed in your machine, which is a requirement. If TreeTagger is not installed in your machine
you can download it from http://www.ims.uni-stuttgart.de/projekte/corplex/TreeTagger/ and follow the installation instructions. To indicate to our scripts where
TreeTagger is located, you have to edit the script core/tt_from_kaf_to_kaf.py and modify the variable complete_path_to_treetagger with the complete path to your
local installation of TreeTagger. By default that variable will point to my own local installation of TreeTagger:
````shell
## Modify this variable to point to your local installation of TreeTagger
complete_path_to_treetagger = '/home/ruben/TreeTagger/'
````

Assuming TreeTagger is installed in /usr/local/TreeTagger, you should modify the variable as:
````shell
## Modify this variable to point to your local installation of TreeTagger
complete_path_to_treetagger = '/usr/local/TreeTagger/'
````



Usage
----


Once installed as a gem you can access the gem from anywhere. The input has to be KAF format with the token layer created.

````shell
cat input.token.kaf | VU-tree-tagger_kernel > output.token.term.kaf
````

In the file output.token.term.kaf we will have the KAF file extended with the term layer (containing both lemma and PoS information)


## Contributing

1. Pull it
2. Create your feature branch (`git checkout -b features/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin features/my-new-feature`)
5. If you're confident, merge your changes into master.

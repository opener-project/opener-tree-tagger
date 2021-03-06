#!/usr/bin/env python
#-*- coding: utf8 *-*
__version__ = '1.2 4-Mar-2013'

## Last changes
# 1-Mar-2013 --> now it works with UTF-8 !!!
# 4-Mar-2013 --> added code for including the element in the linguistic processores header
# 5-Mar-2013 --> language is not a parameter, is read from the input KAF
# 9-dec-2013 --> the postagger avoids 2 terms with the same tokenid span, like 's --> '   and  s
# 11-mar-2014 --> fixed problem when merge with token_matcher
###################################


import sys
import os

this_folder    = os.path.dirname(os.path.realpath(__file__))

# This updates the load path to ensure that the local site-packages directory
# can be used to load packages (e.g. a locally installed copy of lxml).
sys.path.append(os.path.join(this_folder, 'site-packages/pre_install'))

import operator
import time
import getopt
import string
import subprocess
import lxml
from lxml import etree
from lxml.etree import ElementTree as ET, Element as EL, PI
from VUKafParserPy.KafParserMod import KafParser
from token_matcher import token_matcher



if not os.environ.get('TREE_TAGGER_PATH'):
  print>>sys.stderr,"TREE_TAGGER_PATH environment variable not found. Please set the full path to your tree tagger in the TREE_TAGGER_PATH environent variable."
  sys.exit(-1)

complete_path_to_treetagger = os.environ.get('TREE_TAGGER_PATH')


def loadMapping(mapping_file):
  map={}
  filename = os.path.join(os.path.dirname(__file__),mapping_file)
  fic = open(filename)
  for line in fic:
    fields = line.strip().split()
    map[fields[0]] = fields[1]
  fic.close()
  return map



if __name__=='__main__':
  this_folder = os.path.dirname(os.path.realpath(__file__))

  if sys.stdin.isatty():
      print>>sys.stderr,'Input stream required.'
      print>>sys.stderr,'Example usage: cat myUTF8file.kaf |',sys.argv[0]
      sys.exit(-1)

  time_stamp = True
  try:
    opts, args = getopt.getopt(sys.argv[1:],"l:",["no-time"])
    for opt, arg in opts:
      if opt == "--no-time":
        time_stamp = False
  except getopt.GetoptError:
    pass


  input_kaf = KafParser(sys.stdin)
  my_lang = input_kaf.getLanguage()


  if my_lang == 'en':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-english-utf8'
    mapping_file = this_folder +'/english.map.treetagger.kaf.csv'
    model = 'English models'
  elif my_lang == 'nl':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-dutch-utf8'
    mapping_file = this_folder +'/dutch.map.treetagger.kaf.csv'
    model = 'Dutch models'
  elif my_lang == 'de':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-german-utf8'
    mapping_file = this_folder +'/german.map.treetagger.kaf.csv'
    model = 'German models'
  elif my_lang == 'fr':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-french-utf8'
    mapping_file = this_folder +'/french.map.treetagger.kaf.csv'
    model = 'French models'
  elif my_lang == 'it':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-italian-utf8'
    mapping_file = this_folder +'/italian.map.treetagger.kaf.csv'
    model = 'Italian models'
  elif my_lang == 'es':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-spanish-utf8'
    mapping_file = this_folder +'/spanish.map.treetagger.kaf.csv'
    model = 'Spanish models'
  else: ## Default is dutch
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-dutch-utf8'
    mapping_file = this_folder +'/dutch.map.treetagger.kaf.csv'
    model = 'Dutch models'

  map_tt_to_kaf = loadMapping(mapping_file)


  ## Create the input text for
  reference_tokens = []
  sentences = []
  prev_sent='-200'
  aux = []
  for word, sent_id, w_id in input_kaf.getTokens():
    if sent_id != prev_sent:
      if len(aux) != 0:
        sentences.append(aux)
        aux = []
    aux.append((word,w_id))

    prev_sent = sent_id
  if len(aux)!=0:
    sentences.append(aux)


  for sentence in sentences:
    #print>>sys.stderr,'Input sentnece:',sentence
    text = ' '.join(t.encode('utf-8') for t,_ in sentence)

    if not os.path.isfile(treetagger_cmd):
      print>>sys.stderr, "Can't find the proper tree tagger command: " +treetagger_cmd
      raise IOError(treetagger_cmd)
    try:
      tt_proc = subprocess.Popen(treetagger_cmd,stdin=subprocess.PIPE, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    except Exception as e:
      print>>sys.stderr,str(e)

    out, err = tt_proc.communicate(text)

    #print>>sys.stderr,'Output treetagger',out
    data = {}
    new_tokens = []
    for n,line in enumerate(out.splitlines()):
      line = line.decode('utf-8')
      my_id='t_'+str(n)
      token,pos,lemma = line.strip().split('\t')
      pos_kaf = map_tt_to_kaf.get(pos,'O')

      if lemma=='<unknown>':
        lemma=token
        pos+=' unknown_lemma'
      if pos_kaf in ['N','R','G','V','A','O']:
        type_term = 'open'
      else:
        type_term = 'close'
      data[my_id] = (token,pos_kaf,lemma,type_term,pos)
      new_tokens.append((token,my_id))
    #tt_proc.terminate()

    mapping_tokens = {}
    #print
    #print 'SENTENCE',sentence
    #print 'New=tokens',new_tokens
    token_matcher(sentence,new_tokens,mapping_tokens)
    #print mapping_tokens
    #print
    new_terms = []
    terms_for_token = {}
    for token_new, id_new in new_tokens:
      token,pos_kaf,lemma,type_term,pos = data[id_new]
      ref_tokens = mapping_tokens[id_new]
      span = []
      #print token_new, id_new, ref_tokens
      for ref_token in ref_tokens:
        span.append(ref_token)
        if ref_token in terms_for_token:
          terms_for_token[ref_token].append(id_new)
        else:
          terms_for_token[ref_token] = [id_new]

      new_terms.append((id_new,type_term,pos_kaf,pos,lemma,span))


    #print terms_for_token
    not_use = set()
    for id_new,type_term,pos_kaf,pos,lemma,span in new_terms:
      #print not_use
      #print id_new
      if id_new not in not_use:
        new_lemma = ''
        for tokenid in span:
          if len(terms_for_token[tokenid]) > 1:
            new_lemma += (''.join(data[t][2] for t in terms_for_token[tokenid])).lower()
            not_use |= set(terms_for_token[tokenid])
        if new_lemma != '':
          lemma = new_lemma

        ###############
        ele_term = EL('term',attrib={'tid':id_new,
                                      'type':type_term,
                                      'pos':pos_kaf,
                                      'morphofeat':pos,
                                      'lemma':lemma})
        ele_span = EL('span')
        for ref_token in span:
          eleTarget = EL('target',attrib={'id':ref_token})
          ele_span.append(eleTarget)
        ele_term.append(ele_span)
        input_kaf.addElementToLayer('terms', ele_term)
  ##End for each sentence

  input_kaf.addLinguisticProcessor('TreeTagger_from_kaf '+model,'1.0', 'term', time_stamp)
  input_kaf.saveToFile(sys.stdout)



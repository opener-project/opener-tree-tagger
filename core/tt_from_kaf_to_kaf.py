#!/usr/bin/env python
#-*- coding: utf8 *-*

## Modify this variable to point to your local installation of TreeTagger
complete_path_to_treetagger = '/home/ruben/TreeTagger/'

__version__ = '1.2 4-Mar-2013'

## Last changes
# 1-Mar-2013 --> now it works with UTF-8 !!!
# 4-Mar-2013 --> added code for including the element in the linguistic processores header
# 5-Mar-2012 --> language is not a parameter, is read from the input KAF
###################################


import sys
import operator
import time
import getopt
import string
import subprocess
from lxml.etree import ElementTree as ET, Element as EL, PI
from VUKafParserPy.KafParserMod import KafParser
from token_matcher import token_matcher
import os


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
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-english'
    mapping_file = this_folder +'/english.map.treetagger.kaf.csv'
  elif my_lang == 'nl':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-dutch-utf8'
    mapping_file = this_folder +'/dutch.map.treetagger.kaf.csv'    
  else: ## Default is dutch
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-dutch'
    mapping_file = this_folder +'/dutch.map.treetagger.kaf.csv'
  
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
    text = ' '.join(t for t,_ in sentence).encode('utf-8')
    try:
      tt_proc = subprocess.Popen(treetagger_cmd,stdin=subprocess.PIPE, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    except Exception as e:
     print>>sys.stderr,str(e)

    tt_proc.stdin.write(text)
    tt_proc.stdin.close()
  
    data = {}
    new_tokens = []
    for n,line in enumerate(tt_proc.stdout):
      line = line.decode('utf-8')
      my_id='t_'+str(n)
      token,pos,lemma = line.strip().split()
      if lemma=='<unknown>': 
        lemma=token
        pos+=' unknown_lemma'
       
      pos_kaf = map_tt_to_kaf.get(pos,'O')
      if pos_kaf in ['N','R','G','V','A','O']:
        type_term = 'open'
      else:
        type_term = 'close'
      data[my_id] = (token,pos_kaf,lemma,type_term,pos)
      new_tokens.append((token,my_id))
    tt_proc.terminate()
      
    mapping_tokens = {}
    token_matcher(sentence,new_tokens,mapping_tokens)
    for token_new, id_new in new_tokens:
      token,pos_kaf,lemma,type_term,pos = data[id_new]
      
      ele_term = EL('term',attrib={'tid':id_new,
                                   'type':type_term,
                                   'pos':pos_kaf,
                                   'morphofeat':pos,
                                   'lemma':lemma})

      ref_tokens = mapping_tokens[id_new]
      ele_span = EL('span')
      for ref_token in ref_tokens:
        eleTarget = EL('target',attrib={'id':ref_token})
        ele_span.append(eleTarget)
      ele_term.append(ele_span)
      
      input_kaf.addElementToLayer('terms', ele_term)
  ##End for each sentence                                 
                                  
  input_kaf.addLinguisticProcessor('TreeTagger_from_kaf','1.0', 'term', time_stamp)
  input_kaf.saveToFile(sys.stdout)
 


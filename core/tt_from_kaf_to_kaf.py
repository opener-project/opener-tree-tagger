#!/usr/bin/env python
#-*- coding: utf8 *-*

## Modify this variable to point to your local installation of TreeTagger
complete_path_to_treetagger = '/Users/ruben/NLP_tools/TreeTagger/'
__version__ = '1.2 4-Mar-2013'

## Last changes
# 1-Mar-2013 --> now it works with UTF-8 !!!
# 4-Mar-2013 --> added code for including the element in the linguistic processores header
# 5-Mar-2013 --> language is not a parameter, is read from the input KAF
# 9-dec-2013 --> the postagger avoids 2 terms with the same tokenid span, like 's --> '   and  s
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
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-english-utf8'
    mapping_file = this_folder +'/english.map.treetagger.kaf.csv'
  elif my_lang == 'nl':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-dutch-utf8'
    mapping_file = this_folder +'/dutch.map.treetagger.kaf.csv'   
  elif my_lang == 'de':
    treetagger_cmd = complete_path_to_treetagger+'/cmd/tree-tagger-german-utf8'
    mapping_file = this_folder +'/german.map.treetagger.kaf.csv'
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
    #print>>sys.stderr,'Input sentnece:',sentence
    text = ' '.join(t.encode('utf-8') for t,_ in sentence)
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
                                  
  input_kaf.addLinguisticProcessor('TreeTagger_from_kaf','1.0', 'terms', time_stamp)
  input_kaf.saveToFile(sys.stdout)
 


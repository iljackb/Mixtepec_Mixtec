#lang=python
#This file is the 1st step in what I hope will be a program which can collect the sample data from the textgrid+wav files;..
#by opening the latest given log files, sorting them, then appending the results to a masterfile which is constantly updated...
#& saved as a tab separated file with the given data, replacing the previous version.#\
import os
import sys

f = open('./rawtxtform_vowels_f1_f2_f3_mid_tbl_TS_020412.txt')
lines = f.readlines()
vowels = ["a", "e","E","i","O","o","u","a:","e:","E:","i:","O:","o:","u:","a_n", "e_n","E_n","i_n","O_n","o_n","u_n", "a:_n","e:_n","E:_n","i:_n","O:_n","o:_n","u:_n","a_k", "e_k","E_k","i_k","O_k","o_k","u_k", "a_n_k", "e_n_k","E_n_k","i_n_k","O_n_k","o_n_k","u_n_k","a:_n_k","e:_n_k","E:_n_k","i:_n_k","O:_n_k","o:_n_k","u:_n_k"]
nasal_vowels = ["a_n","e_n","E_n","i_n","O_n","o_n","u_n","a:_n","e:_n","E:_n","i:_n","O:_n","o:_n", "u:_n"]
creaky_vowels = ["a_k","e_k","E_k","i_k","O_k","o_k","u_k","a:_k","e:_k","E:_k","i:_k","O:_k","o:_k","u:_k"]
creaky_nasal_vowels = ["a_n_k", "e_n_k","E_n_k","i_n_k","O_n_k","o_n_k","a:_n_k","e:_n_k","E:_n_k","i:_n_k","O:_n_k","o:_n_k","u:_n_k"]
vowel_tokens = []
f1_tks = []
f2_tkns = [] 
f3_tkns = []


def open_file(filePath):
	vowelFormatFile = open(filePath)
	


def get_tokens('vowels','file)

def _(pos, lines):
        out = []
        for line in lines:
		
                vowel, f1, f2, f3  = line.strip().split('/t')
                for line in lines:
                        parts = each.split('/t')
                        if len(parts)==4:
                                Vowel = parts[0]
                                F1_mid = parts[1]
				F2_mid = parts[2]
				F3_mid = parts[3]
 			
                                        out.append()
        return out


#I can make functions for all main measures I want to collect.(i.e.; <def get_f0_@times( )>...#

lines = sys.stdin.readlines()
f1 = 
get_tokens('vowels','file)

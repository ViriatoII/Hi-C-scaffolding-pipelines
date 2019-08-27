#!/usr/bin/env python

## calculate N50 from fasta file     ### python2
## N50 = contig length so that half of the contigs are longer and 1/2 of contigs are shorter

import commands
import sys
import os
from itertools import groupby
import numpy
import zipfile
import gzip
# from Bio import SeqIO

lengths = []
n_number = 0


the_input= sys.argv[1]

if str(the_input).endswith("gz"):    

	with gzip.open(the_input) as fasta:
    		## parse each sequence by header: groupby(data, key)
    		faiter = (x[1] for x in groupby(fasta, lambda line: line[0] == ">"))

		for record in faiter:
        		## join sequence lines
        		seq = "".join(s.strip() for s in faiter.next())
        		lengths.append(len(seq))
			n_number = n_number + seq.count("N")



else:
	with open(the_input) as fasta:
    	## parse each sequence by header: groupby(data, key)
		faiter = (x[1] for x in groupby(fasta, lambda line: line[0] == ">"))

		for record in faiter:
        		## join sequence lines
        		seq = "".join(s.strip() for s in faiter.next())
        		lengths.append(len(seq))
			n_number = n_number + seq.count("N")




Total_size = int(sum(lengths))

print "Contigs: %s" % len(lengths)

## sort contigs longest>shortest
all_len = numpy.array( sorted(lengths, reverse=True) )  # sorted lengths ; numpy.array is faster
csum = numpy.cumsum(all_len) 


## Count contigs > threshhold

print "Contigs >= 5000 bps: %s" % sum (all_len >=   5000) 
print "Contigs >= 10000 bps: %s" % sum(all_len >=  10000)
print "Contigs >= 25000 bps: %s" % sum( all_len >= 25000)
print "Contigs >= 50000 bps: %s" % sum( all_len >= 50000)
print "Contigs >= 100000 bps: %s" % sum( all_len >= 100000)

print "Largest contig: %s" % all_len[0]
print "Total size: %d" % Total_size

print "Length >= 5000 bps: %s" % sum(all_len[all_len >=    5000])     # Boolean indexing
print "Length >= 10000 bps: %s" % sum(all_len[all_len >=  10000])
print "Length >= 25000 bps: %s" % sum(all_len[all_len >=  25000])
print "Length >= 50000 bps: %s" % sum(all_len[all_len >=  50000])
print "Length >= 100000 bps: %s" % sum(all_len[all_len >= 100000])


n2=int(sum(lengths)/2)

# get index for cumsum >= N/2
csumn2=min(csum[csum >= n2])
ind=numpy.where(csum == csumn2)


n50 = all_len[int(ind[0])]
print "N50: %s" % n50

## N90
nx90=int(sum(lengths)*0.90)

## index for csumsum >= 0.9*N
csumn90=min(csum[csum >= nx90])
ind90=numpy.where(csum == csumn90)

n90 = all_len[int(ind90[0])]
print "N90: %s" % n90

L50 = int(ind[0])
print "L50: %s" % L50

L90 = int(ind90[0])
print "L90: %s" % L90

print "Ns per 100 kbs: ", (n_number*100000)/Total_size
## write lengths to file
#with open('all_lengths.txt', 'w') as handle:
#	handle.write('\n'.join(str(i) for i in lengths))

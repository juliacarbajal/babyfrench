# This Python file uses the following encoding: utf-8

# ---- Description ----
# This script loads a pre-processed compilation of CHILDES corpora
# and creates a word dictionary with token counts binned by age
#
# Written by Julia Carbajal, LSCP (ENS, Paris, France), October 2017

# ---- Load corpus ----
corpus = []
with open('corpus_ortho_0y0m_2y0m_withFileInfo_noParnths.txt') as recoded_file:
	for line in recoded_file:
		corpus.append(line.strip())

# ---- Build word dictionary ----
word_dict = {}
bins = range(11,25)
for line in corpus:
	line = line.split()
	age = int(line[2])*12 + int(line[3]) # Age in months
	bin = [i for i, v in enumerate(bins) if v == age]
	if bin:
		# Retrieve and count words:
		for word in line[5:]:
			if (word not in word_dict):
				word_dict[word] = [0]*len(bins)
				word_dict[word][bin[0]]   = 1 # Add word to the dictionary
			else:
				word_dict[word][bin[0]]  += 1 # Add +1 to the count of observations of current word

# ---- Print ----
f = open('binned_word_count_0y11m_2y0m.txt', 'w')
# Header
print >> f, 'word' + ',' + ','.join('m.'+str(x) for x in bins)
# Word counts
for word, count in sorted(word_dict.iteritems()):
	if (word not in [',','.',';','?','!']):
		print >> f, '"' + word + '"' + ',' + ','.join(str(x) for x in count)
f.close()
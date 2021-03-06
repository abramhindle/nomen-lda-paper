import count_annotations as A
import get_exps as G
import check_validity as V
from collections import defaultdict
import warnings
import unicodedata


# returns a dictionary of word counts
def word_count_of_topics( topics ):
    tgen = ( A.histogram(words_of_topic(t)) for t in topics)
    rdict = A.histogram([]) #makea  new histogram
    word_counts = reduce(A.hist_add , tgen , rdict)
    return word_counts

    
def annotations_of_topics( topics ):
    return [ annotations_of_topic( t ) for t in topics ]

# return a tuple of annotations, thresh_el
def annotations_and_words_of_topic( topic ):
    return V.create_element_list( topic )

def words_of_topic( topic ):
    annotations, thresh_el = V.create_element_list( topic )
    return thresh_el

def annotations_of_topic( topic ):
    annotations, thresh_el = V.create_element_list( topic )
    return annotations


def arff_char( c ):
    if (c.isalnum()):
        return c
    else:
        return '_'

def arff_escape( word ):
    if (word.isalnum()):
        return word
    else:
        return "".join([ arff_char(c) for c in word ])

def arff_header( name, columns ):
    strs = ["@RELATION "+name ] + \
           [ ("@ATTRIBUTE " + word_and_type) for word_and_type in columns] + \
           [ "@DATA" ]
    return [ x + "\n" for x in strs ]

def arff_escape_words(words):    
    word_columns = [ i_hate_python_and_unicode(arff_escape(w)) for w in words]
    wcdict = {}
    out_word_columns = []
    for word in word_columns:
       wword = word
       if (word in wcdict):
         wword += "__DUPLICATE__"+str(wcdict[word])
	 wcdict[word] += 1
	 wcdict[wword] = 1
       else:
         wcdict[word] = 1
       #if ("Bj" in wword):
       #    print("Found a Bjorklund "+word+" -- "+wword)           
       out_word_columns.append( wword )
    # a check
    #for word in out_word_columns:
    #    count = 0
    #    for word2 in out_word_columns:
    #        if word == word2:
    #            count += 1
    #    if (count > 1):
    #        print(word + " is a duplicate with count " + str(count))
    return out_word_columns



def to_arff( name, xperiods ): #name, inputdir, periods ):
    topics = A.flatten([ A.get_topics(x) for x in xperiods ])
    # summarize the words and order by most common
    word_counts = word_count_of_topics( topics )
    indextoword, wordtoindex = A.map_words_to_index( word_counts )
    nwords = len( word_counts.keys() )
    words = [indextoword[i] for i in range(nwords)]
    # summarize the annotations and order by most common
    anno_hist = A.summarize_annotations_of_topics( topics )
    indextoanno, annotoindex = A.map_words_to_index( anno_hist, cnt = nwords )
    nannos = len( anno_hist.keys() )
    # note the + nwords part
    annos = [indextoanno[i + nwords] for i in range(nannos)]
    # total # of columns
    ncolumns = nannos + nwords
    allcolumns = words + annos

    # words to ARFF Escapes
    out_word_columns = arff_escape_words(words)

    
    # header is a list of strings
    # too much arff right here.. oh well

    header = arff_header( name , ["W_"+w+" INTEGER" for w in out_word_columns] + ["A_"+arff_escape(a)+" {0,1}" for a in annos] )
    data = []
    for t in topics:
        tannotations, twords = V.create_element_list( t )
        l = [ 0 for x in range(nwords) ] + [ "0" for x in range(nannos) ]
        for tanno in tannotations:
            l[annotoindex[tanno]] = "1"
        for tword in twords:
            l[wordtoindex[tword]] += 1
        sgen = ( str(x) for x in l )
        data.append(",".join(sgen) + "\n")
    return header + data

# def to_arff_data( xperiod, nwords, nannos, annotoindex, wordtoindex ):
#     topics = A.flatten([ A.get_topics(x) for x in xperiods ])
#     data = []
#     for t in topics:
#         tannotations, twords = V.create_element_list( t )
#         l = [ 0 for x in range(nwords) ] + [ "0" for x in range(nannos) ]
#         for tanno in tannotations:
#             l[annotoindex[tanno]] = "1"
#         for tword in twords:
#             l[wordtoindex[tword]] += 1
#         sgen = ( str(x) for x in l )
#         data.append(",".join(sgen) + "\n")
#     return data
# 
# def to_arff2( name, xperiod1, xperiod2 ): #name, inputdir, periods ):
#     xperiodst = [ xperiod1, xperiod2 ]
#     xperiods = A.flatten(xperiodst)
#     topics = A.flatten([ A.get_topics(x) for x in xperiods ])
#     # summarize the words and order by most common
#     word_counts = word_count_of_topics( topics )
#     indextoword, wordtoindex = A.map_words_to_index( word_counts )
#     nwords = len( word_counts.keys() )
#     words = [indextoword[i] for i in range(nwords)]
#     # summarize the annotations and order by most common
#     anno_hist = A.summarize_annotations_of_topics( topics )
#     indextoanno, annotoindex = A.map_words_to_index( anno_hist, cnt = nwords )
#     nannos = len( anno_hist.keys() )
#     # note the + nwords part
#     annos = [indextoanno[i + nwords] for i in range(nannos)]
#     # total # of columns
#     ncolumns = nannos + nwords
#     allcolumns = words + annos
#     # header is a list of strings
#     # too much arff right here.. oh well
#     header = arff_header( name , ["W_"+arff_escape(w)+" INTEGER" for w in words] + ["A_"+arff_escape(a)+" {0,1}" for a in annos] )
#     data1 = to_arff_data( xperiod1, nwords, nannos, annotoindex, wordtoindex )
#     data2 = to_arff_data( xperiod2, nwords, nannos, annotoindex, wordtoindex )
#     return [(header + data1), (header+data2)]

def save_arff( filename, lines):
    FILE = open(filename, "w")
    FILE.writelines( lines )
    FILE.close
        
def i_hate_python_and_unicode( maybe_a_unicode_string ):
    if (type(maybe_a_unicode_string) == type("")):
       return maybe_a_unicode_string
    return unicodedata.normalize('NFKD', maybe_a_unicode_string).encode('ascii','ignore')

def arff_clean_up( arff ):
    return [i_hate_python_and_unicode(x) for x in arff]

if __name__ == '__main__':
    exps = G.get_exps()
    xp = []
    xps = [0,0]
    outputdir = "output"
    for e in exps:
        print ("Dealing with " + e[0])
        name = e[0]
        ndir = e[1]
        periods = e[2]
        xperiods = A.load_periods( ndir, periods )
        xp.append( xperiods )
        arff = to_arff( name, xperiods )
        arff = arff_clean_up(arff)
        for line in arff:
            if (type("") != type(line)):
                warnings.warn("A line is not a string!"+str(type(line)) + str(line))
        #warnings.warn(str(len(arff)))
        save_arff( outputdir + "/" + name + ".arff" , arff )
    # now do everything at once ALL PROJECTS
    names = [e[0] for e in exps]
    name = "__".join(names)
    print("Now dealing with "+name)
    arff = to_arff( name, A.flatten( xp ) )
    arff = arff_clean_up(arff)
    # commented temporarily
    save_arff( outputdir + "/" + name + ".arff" , arff )
    # arffs = to_arff2( name, xp[0], xp[1] )
    # save_arff( outputdir + "/1-" + name + ".arff" , arffs[0] )
    # save_arff( outputdir + "/2-" + name + ".arff" , arffs[1] )
    
	
	
    


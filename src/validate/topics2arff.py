import count_annotations as A
import check_validity as V
from collections import defaultdict


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
    # header is a list of strings
    header = arff_header( name , ["W_"+arff_escape(w)+" INTEGER" for w in words] + ["A_"+arff_escape(a)+" {No,Yes}" for a in annos] )
    data = []
    for t in topics:
        tannotations, twords = V.create_element_list( t )
        l = [ 0 for x in range(nwords) ] + [ "No" for x in range(nannos) ]
        for tanno in tannotations:
            l[annotoindex[tanno]] = "Yes"
        for tword in twords:
            l[wordtoindex[tword]] += 1
        sgen = ( str(x) for x in l )
        data.append(",".join(sgen) + "\n")
    return header + data

def save_arff( filename, lines):
    FILE = open(filename, "w")
    FILE.writelines( lines )
    FILE.close
        

    

if __name__ == '__main__':
    exps = A.get_exps()
    xp = []
    outputdir = "output"
    for e in exps:
        print ("Dealing with " + e[0])
        name = e[0]
        ndir = e[1]
        periods = e[2]
        xperiods = A.load_periods( ndir, periods )
        xp.append( xperiods )
        arff = to_arff( name, xperiods )
        save_arff( outputdir + "/" + name + ".arff" , arff )
    # now do everything at once ALL PROJECTS
    names = [e[0] for e in exps]
    name = "__".join(names)
    print("Now dealing with "+name)
    arff = to_arff( name, A.flatten( xp ) )
    save_arff( outputdir + "/" + name + ".arff" , arff )
    


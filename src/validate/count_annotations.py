import lxml.etree
import operator
import string
from lxml.builder import E
from collections import defaultdict
import get_exps as G
import quality_map as Q


# * TODO
#   - [X] Per Period annotation plot (1 period)
#   - [X] Per PERIODS annotation plot (everything)
#   - [X] for all periods PER period annotation plot
#   - [X] Global sum of all periods plot
#   - [ ] Time-wise plot of annotation count
#   - [ ] Time-wise plot of annotations [stacked]? [rotated?]
#   - [ ] Topic Plots?
#   - [ ] CLean up data


def hist_add(hist1,hist2):
    rdict = defaultdict(int)
    for hist in [ hist1, hist2 ] :
        for (key,val) in hist.iteritems ():
            rdict[key] += val
    return rdict

#mutates the histogram
#mhist1 is a defaultdict
def mutable_hist_add(mhist1, chist2):
    for hist in [ chist2 ] :
        for (key,val) in hist.iteritems ():
            mhist1[key] += val
    return mhist1


def summarize_periods(periods):
    """
    This counts annotations over a few periods
    """
    rdict = defaultdict(int)
    agen = ( summarize_annotations_of_period(x) for x in periods )
    s = reduce(hist_add, agen ,rdict) #sum 
    return s

def summarize_both_period_and_periods(periods):
    """
    This counts annotations over a few periods
    And it returns the summarized annotations
    """
    rdict = defaultdict(int)
    alist = [ summarize_annotations_of_period(x) for x in periods ]
    periodslist = reduce(hist_add, alist ,rdict) #sum 
    return (alist, periodslist)

# returns 2 dicts
#   ikdict is index to key
#   kidict is key to index
def map_words_to_index ( words_dict , cnt = 0 ):
    """
    Assumption! name is not a integer!
    """
    rev = [ (x[1],x[0]) for x in words_dict.items() ]
    rev.sort() #rev mutated >:(
    rev.reverse() #ascending (mutated!)
    ikdict = {}
    kidict = {}
    # cnt is index
    for (count, name) in rev:        
        ikdict[cnt] = name
        kidict[name] = cnt
        cnt = cnt + 1
    return ikdict, kidict
    

def map_annotations_to_index( annotation_count_dict ):
    """
    Assumption! name is not a integer!
    """
    rev = [ (x[1],x[0]) for x in annotation_count_dict.items() ]
    rev.sort() #rev mutated >:(
    rev.reverse() #ascending (mutated!)
    odict = {}
    cnt = 0
    for (count, name) in rev:        
        odict[cnt] = name
        odict[name] = cnt
        cnt = cnt + 1
    return odict

def summarize_annotations_of_period(period):
    """
    returns a dictionary of keys and counts of annotations in the period
    expects xml periods
    """
    topics = get_topics(period)
    return summarize_annotations_of_topics( topics )

def summarize_annotations_of_topics( topics ):
    simple_annotations = [ get_simple_annotations(x) for x in topics ]
    total_annotations = flatten(simple_annotations)
    ann_hist = histogram(total_annotations)
    return ann_hist

def summarize_annotations_of_topic(topic):
    simple_annotations = get_simple_annotations(topic)
    total_annotations = flatten(simple_annotations)
    ann_hist = histogram(total_annotations)
    return ann_hist

def histogram(l):
    histogram = defaultdict(int)
    for x in l:
        histogram[x] += 1
    return histogram

def flatten(l):
    return sum(l,[]) # are you serious? come on ...

def get_topics(period):
    topics = period.findall('Topic')
    return topics

def get_simple_annotations(topic):
    annotations = get_annotations(topic)
    annotationnames = [x.attrib['name'] for x in annotations]
    return Q.annotations_to_qualities( annotationnames )

def get_annotations(topic):
    anno = topic.findall('Annotation') or topic.findall('annotation')
    return anno

def get_exps():
    return G.get_exps()

def period_file( ndir, period ):
    period_file = ndir + period + '.xml'
    return period_file

# returns the etree 
def load_period_file( ndir, period ):
    tree = lxml.etree.parse( period_file( ndir, period ) )
    return tree

def boxplot( plot_name, column_names, row_name, column_counts ):
    plot =  E.boxplot(
              E.plot_name( plot_name ),
              E.row_names( E.row_name(row_name) ),
              E.column_names( *[E.column_name(x) for x in column_names] ), #note the *
              E.rows(  "\t".join([str(x) for x in column_counts]) )
              )
    stri = lxml.etree.tostring(plot, pretty_print=True)
    return stri

def stacked_boxplot( plot_name, column_names, row_names, rows ):
    plot =  E.stacked_boxplot(
               E.plot_name( plot_name ),
               E.row_names( *[E.row_name(x) for x in row_names] ),
               E.column_names( *[E.column_name(x) for x in column_names] ),
               E.rows( "\n".join( [ "\t".join([str(y) for y in x]) for x in rows ] ))
               )
    stri = lxml.etree.tostring(plot, pretty_print=True)
    return stri

def boxplot_to_file( bpfile, period_name, annotation_names, row_name, lcnt ):
    data = boxplot( period_name, annotation_names, row_name, lcnt )
    FILE = open( bpfile, "w" )
    FILE.write( data )
    FILE.close()
    return True

def stacked_boxplot_to_file( bpfile, name, annotation_names, row_names, lcnts ):
    data = stacked_boxplot( name, annotation_names, row_names, lcnts )
    FILE = open( bpfile, "w" )
    FILE.write( data )
    FILE.close()
    return True

def load_periods( ndir, periods ):
    xperiods = [ load_period_file( ndir , p ) for p in periods ]
    return xperiods

def per_period_reports( name , ndir , periods, odir ):
    """
    this writes to files in odir!
    """
    print "Loading periods"
    xperiods = load_periods( ndir, periods ) 
    print "Summarizing periods"
    res = summarize_both_period_and_periods( xperiods )
    annotated_periods = res[0]
    global_annotations = res[1]
    print "Generating index"
    index_dict = map_annotations_to_index( global_annotations )
    total_tations = len(global_annotations)
    print "Getting column names"
    annotation_names = [ index_dict[x] for x in range(total_tations) ]
    # TODO: maybe filter out crap periods
    lcnts = []
    for (period_name, period, annotates) in zip(periods , xperiods, annotated_periods):
        # lcnt is going to be the annotation count
        # indexed by index_dict, but the count
        print ("Period handling: " + period_name)
        lcnt = [0 for x in range(total_tations)]
        for (key,cnt) in annotates.items():
            lcnt[ index_dict[key] ] += cnt
        bpfile = odir + "/" + name + ".period." + period_name  + ".boxplot.xml"
        print "Generating boxplot"
        boxplot_to_file( bpfile, period_name, annotation_names, period_name,  lcnt )
        lcnts.append( lcnt ) # saving the output
    # now each period has its own fil
    print "Generating stacked plot"
    sbpfile = odir + "/" + name + ".stacked_boxplot.xml"
    stacked_boxplot_to_file( sbpfile, name, annotation_names, periods,  lcnts )

    # sum all of lcnts per column
    count_lct = [ sum([ l[x] for l in lcnts ]) for x in range(total_tations) ]

    tbpfile = odir + "/" + name + ".total.boxplot.xml"
    boxplot_to_file( tbpfile, name, annotation_names, "Total", count_lct )
    
    return True

def get_pg_author_counts():
    """
    Retrieve the author contributions (commits) in Postgres for ESE paper
    """
    exps = G.get_exps()
    pgsql_dir = exps[2][1]
    pgsql_periods = exps[2][2]
    pg_nfr_db = {"usability":{},"efficiency":{},"functionality":{},"reliability":{},"maintainability":{},"none":{},"portability":{}}
    for key in pg_nfr_db.keys():
        pg_nfr_db[key] = defaultdict(int) #"momjian":33 defaultdict provides an integer default if no key found
    for period in pgsql_periods:
        tree = load_period_file( pgsql_dir, period )
        root = tree.getroot() # assume this is the root element Period
        #print root.get( "time" )
        for element in root.iter("Topic"):
            anno = []
            auth = []
            for a in element.iter():
                if a.tag == "Annotation" or a.tag == "annotation":
                    anno.append(string.lower(a.get( "name" )))
                if a.tag == "Author":
                    auth.append(a.get( "name" ))
            for nfr in anno:
                for author in auth:
                    pg_nfr_db[nfr][author] = pg_nfr_db[nfr][author] + 1
    return pg_nfr_db 
    
def format_author_nfr(author_nfr_map,print_by_nfr=True):
    """This will pretty print the code that sums authors."""
    out = [] # careful, not all NFRs have the author.
    for key in author_nfr_map.keys():
        print key
        for author in author_nfr_map[key].keys():
            if author == 'wieck':
                print author_nfr_map[key][author]
                out.append(str(author_nfr_map[key][author]))
    print ','.join(out)               
# The main for this program
# load up periods per project
# and the write out if a project
if __name__ == '__main__':
    x = {'none': {'momjian': 19, 'thomas': 4, 'davec': 2, 'neilc': 1, 'ishii': 3, 'darcy': 1, 'barry': 2, 'inoue': 1, 'pgsql': 1, 'meskes': 2, 'petere': 7, 'tgl': 21, 'joe': 1}, 
         'portability': {'momjian': 221, 'thomas': 5, 'davec': 22, 'neilc': 25, 'ishii': 12, 'darcy': 4, 'barry': 23, 'wieck': 8, 'inoue': 7, 'pgsql': 9, 'teodor': 18, 'jurka': 9, 'meskes': 62, 'scrappy': 6, 'petere': 97, 'dennis': 7, 'tgl': 217, 'joe': 11}, 
         'efficiency':  {'momjian': 129, 'thomas': 6, 'davec': 10, 'neilc': 22, 'ishii': 13, 'barry': 23, 'wieck': 4, 'inoue': 10, 'pgsql': 7, 'teodor': 10, 'jurka': 6, 'meskes': 21, 'scrappy': 2, 'petere': 47, 'dennis': 4, 'tgl': 125, 'joe': 4}, 
         'reliability':  {'momjian': 156, 'thomas': 6, 'davec': 17, 'neilc': 23, 'ishii': 10, 'darcy': 3, 'barry': 34, 'wieck': 5, 'inoue': 9, 'pgsql': 3, 'teodor': 7, 'jurka': 12, 'meskes': 38, 'scrappy': 4, 'petere': 61, 'dennis': 3, 'tgl': 157, 'joe': 11}, 
         'functionality':  {'momjian': 230, 'thomas': 18, 'davec': 33, 'neilc': 21, 'ishii': 21, 'darcy': 4, 'barry': 36, 'wieck': 13, 'inoue': 17, 'pgsql': 9, 'teodor': 19, 'jurka': 8, 'meskes': 58, 'scrappy': 3, 'petere': 99, 'dennis': 4, 'tgl': 227, 'joe': 6}, 
         'maintainability':  {'momjian': 138, 'thomas': 9, 'davec': 18, 'neilc': 15, 'ishii': 22, 'darcy': 4, 'barry': 23, 'wieck': 3, 'inoue': 10, 'pgsql': 8, 'teodor': 10, 'jurka': 7, 'meskes': 28, 'scrappy': 5, 'petere': 68, 'tgl': 135, 'joe': 5}, 
         'usability':  {'momjian': 175, 'thomas': 7, 'davec': 18, 'neilc': 35, 'ishii': 12, 'darcy': 2, 'barry': 27, 'wieck': 10, 'inoue': 7, 'pgsql': 7, 'teodor': 14, 'jurka': 6, 'tgl': 176, 'scrappy': 2, 'petere': 96, 'dennis': 11, 'meskes': 48, 'joe': 9}}

    format_author_nfr( x )
    #exps = get_exps()
    #assert(len(exps) >= 2)
    #for e in exps:
        #print ("Dealing with " + e[0])
        #per_period_reports( e[0], e[1], e[2], "output/" )

import lxml.etree
import operator
from lxml.builder import E
from collections import defaultdict

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
    counts = {}
    topics = get_topics(period)
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
    return annotationnames

def get_annotations(topic):
    anno = topic.findall('Annotation') or topic.findall('annotation')
    return anno

def get_exps():
    maxdb_periods = ["1088563753", "1098931753",   "1119667753",  "1132627753",  "1142995753", 
                    "1091155753",  "1101523753",  "1122259753",  "1135219753",  "1145587753", 
                    "1093747753",  "1104115753",  "1124851753",  "1137811753",  "1148179753", 
                    "1096339753",  "1106707753",  "1130035753",  "1140403753",  "1150771753"]
    mysql_periods = ["965099404" ,"967691404" ,"970283404" ,"972875404" ,"975467404" ,"978059404" ,"980651404" ,"983243404" ,"985835404" ,"988427404" ,"991019404" ,"993611404" ,"996203404" ,"998795404" ,"1001387404" ,"1003979404" ,"1006571404" ,"1009163404" ,"1011755404" ,"1014347404" ,"1016939404" ,"1019531404" ,"1022123404" ,"1024715404" ,"1027307404" ,"1029899404" ,"1032491404" ,"1035083404" ,"1037675404" ,"1040267404" ,"1042859404" ,"1045451404" ,"1048043404" ,"1050635404" ,"1053227404" ,"1055819404" ,"1058411404" ,"1061003404" ,"1063595404" ,"1066187404" ,"1068779404" ,"1071371404" ,"1073963404" ,"1076555404" ,"1079147404" ,"1081739404" ,"1084331404" ,"1086923404" ,"1089515404" ,"1092107404"]
    maxdb_dir = "data/maxdb-tagged/"
    mysql_dir = "data/mysql-tagged/"
    exprs = [ ["maxdb",maxdb_dir, maxdb_periods] , [ "mysql",mysql_dir, mysql_periods ] ]
    return exprs

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

def per_period_reports( name , ndir , periods, odir ):
    """
    this writes to files in odir!
    """
    print "Loading periods"
    xperiods = [ load_period_file( ndir , p ) for p in periods ]
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
    
# The main for this program
# load up periods per project
# and the write out if a project
if __name__ == '__main__':
    exps = get_exps()
    assert(len(exps) >= 2)
    for e in exps:
        print ("Dealing with " + e[0])
        per_period_reports( e[0], e[1], e[2], "output/" )

        
        
        


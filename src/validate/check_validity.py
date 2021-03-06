# Suite of functions to parse word lists
import get_exps
import info_theory
import quality_map as Q
from collections import defaultdict

def make_count():
    return defaultdict(int)


# As far as I can tell this script is meant to see if
# the annotations match or don't match portability efficiency reliability etc..
def load_period(period, data_dir = "../../data/maxdb-tagged/"): 
    """ load the xml file with the data """
    period_file = period + '.xml'
    
    import lxml.etree
    doc = lxml.etree.parse(data_dir + period_file)
    topics = doc.findall('Topic')
    #spme test establishing correct number
    return topics
 

#def load_wordlists(expdir = '../exp3/' ): 
#    """ load the datafile with the wordlists we want to use """
#    quality_map = {'portability':[], 'efficiency':[], 'reliability':[], 'functionality':[], 'usability':[], 'maintainability':[]}
#    for q in quality_map.keys():
#        q_file = open( expdir + 'wordlist.' + q )
#        for line in q_file:
#            quality_map[ q ].append( line.rstrip() )
#    return quality_map
    
def create_element_list(topic):
    """Parse each period and create a list of elements and annotations in that topic, 
    to some threshold. arg topic is an ElementTree Element"""
    threshold = -99.0
    annotations = []
    thresh_el = [] # the list of elements 'above' the threshold
    import re
    url = re.compile('http:\/\/.*') # this will parse out (some) urls 
    elements = topic.findall('Elements/Elm') # should use some sort of comprehension here to filter on threshold
    for elm in elements:
        if float(elm.attrib['freq']) > threshold and url.match(elm.attrib['word']) == None:
            thresh_el.append(elm.attrib['word'])
    
    anno = topic.findall('Annotation') or topic.findall('annotation')
    for a in anno:
        annotations.append(a.attrib['name'])
    annotations2 = Q.annotations_to_qualities( annotations )
    return annotations2, thresh_el
    
def index_matching_wordlists( thresh_el, annotations, quality_map ):
    el_results = {}
    anno_results = []
    count = 0
    # for each non functional requirement 
    matching_words = []
    for quality in quality_map.keys():
        count = 0
        # for each word in the quality map
        for keyword in quality_map[quality]:
            #
            if keyword in thresh_el:
                matching_words.append( (quality, keyword) )
                count = count + 1 #count of occurences for that quality's keywords
        # assign the count to that quality
        el_results[quality] = count

    matches = [x for x in el_results.keys() if el_results[x] > 0]  # only print matches   
    overlap = False      
    # this was a little hard to read
    #overlap = len([ m for m in matches if m in annotations ]) > 0 or \
    #           (len(annotations) > 0 and annotations[0] == 'none')
    # We want to check if there no annotations or it was annotated NONE
    # then we want to check if matches overlaps ok?
    # i have no clue why none and zip for annotations means anything
    anno_matches = [m for m in matches if m in annotations]
    nanno_matches = len( anno_matches )
    nannos = 0
    if (len(annotations) == 0):
        overlap = True
        nanno_matches = 0
    elif ("none" in annotations):
        overlap = True
        nanno_matches = 0
    else:
        nannos = len( annotations )
        overlap = len( anno_matches ) > 0

    #for m in matches:
    #    if m in annotations or (len(annotations) > 0 and annotations[0] == 'none'):
    #        overlap = True
    # the script used to print here.

    return overlap, (anno_matches, matches, matching_words), ( nanno_matches , nanno_matches )

    # if overlap:
    #     return 'yes'
    # else:
    #     return "no match"

def info_report_string(key, tp, fp, fn, tn):
    #s1 = key + ","+ ",".join(["tp","fp","fn","tn"])+"\n"
    #s2 = key + ","+ ",".join([str(x) for x in [tp,fp,fn,tn]])+"\n"
    im = info_theory.info_measures(tp,tn,fp,fn)
    ik = im.keys()
    ik.sort()
    #strhead = key + "," + ",".join(ik)
    strb = key + "," + ",".join([str(y) for y in [im[x] for x in ik]])
    return "\n" + strb #+ "\n"#join([s1,s2,strhead,strb]) + "\n"



# Create a list of annotations indexed to period/topic.
# Compare the annotation qualities per period/topic to the list generated by lda.
# The main for this program
# load up periods per project
# and the write out if a project
if __name__ == '__main__':
    exps = get_exps.get_exps() 
    # test_period = '1098931753'
    #     topics = load_period(test_period)
    word_exps = get_exps.word_list_exps()
    for wl in word_exps:
        #wld = get_exps.word_list_dir( wl )
        print wl
        quality_map = get_exps.load_wordlists( wl )
        for exp in exps:
            #print exp
            ddir = exp[1]
            periods = exp[2]
            report = exp[0]
            report_file = wl + "." + report + ".report.txt"
            rfile = open( report_file, "w" )
            print report
            rfile.write(report+'\n')
            yes_no_report_file = wl + "." + report + ".yes_no_report.txt"
            ynfile = open( yes_no_report_file, "w" )
            ynfile.write(report+'\n')
            tp = make_count() #true positive  - matches but is
            fp = make_count() #false positive - matches but isn't
            fn = make_count() #false negative - doesn't match but does
            tn = make_count() #true negative  - doesn't match but isn't
            yes = 0
            no = 0
            yncount = 0
            for period in periods:
                pstr = "Period #" + period
                #print pstr
                #rfile.write(pstr+'\n')
                ynfile.write(pstr+'\n')
                topics = load_period(period, data_dir = ddir)
                for t in topics:
                    annotations, thresh_el = create_element_list(t)
                    res, ma, stats = index_matching_wordlists(thresh_el, annotations, quality_map)
                    anno_matches = ma[0]
                    matches = ma[1] #matching qualities
                    matching_words = ma[2]

                    # Get our matching grids
                    # left here
                    # true positives
                    for a in anno_matches:
                        if a in quality_map:
                            tp[a] += 1

                    #for a in matches:
                    # something matched but is not an annotation..
                    # false positives
                    #   matched but not annotated
                    for a in [x for x in matches if not x in annotations]:
                        if a in quality_map:
                            fp[a] += 1

                    # false negatives
                    #  annotated but not matching
                    for a in [x for x in annotations if not x in matches]:
                        if a in quality_map:
                            fn[a] += 1

                    # true negatives
                    # didn't match and wasn't annotated
                    for a in [x for x in quality_map if not (x in annotations or x in matches)]:
                        if a in quality_map:
                            tn[a] += 1

                    ress = "Yes"
                    #if not res: # return No if there were no automatches
                    if len( matches) ==0  :
                        no += 1
                        ress = "No"
                    else:
                        yes += 1
                    yncount += 1
                    #print res
                    ynfile.write(ress+'\n')
                 
            tpc = sum(tp.values(),0)        
            fpc = sum(fp.values(),0)        
            tnc = sum(tn.values(),0)        
            fnc = sum(fn.values(),0)
            for key in quality_map:
                istr = info_report_string(key, tp[key], fp[key], fn[key], tn[key])
                print istr
                rfile.write(istr)
            istr = info_report_string("\ntotal", tpc, fpc, fnc, tnc)
            print istr
            rfile.write(istr)        
                
            # 
            rfile.close()
            ynfile.write('################################\n');
            ynfile.write('Named: ' + str(yes) + '\n')
            ynfile.write('UnNamed: ' + str(no) + '\n')
            ynfile.write('Total: ' + str(yncount) + '\n')
            total_topics = 20 * len( periods ) # check out the magic number
            ynfile.write('Total possible topics:' + str( total_topics ) + '\n')
            ynfile.write('Blank topics:' + str(  total_topics - yncount ) + '\n')
            ynfile.close()

# Suite of functions to parse word lists

# As far as I can tell this script is meant to see if
# the annotations match or don't match portability efficiency reliability etc..

def load_period(period, data_dir = "/Users/nernst/Documents/papers/current-papers/abram/naming-paper/data/maxdb-tagged/"): 
    """ load the xml file with the data """
    period_file = period + '.xml'
    
    import lxml.etree
    doc = lxml.etree.parse(data_dir + period_file)
    topics = doc.findall('Topic')
    #spme test establishing correct number
    return topics
    
def load_wordlists(): 
    """ load the datafile with the wordlists we want to use """
    exp = '../exp3/'
    quality_map = {'portability':[], 'efficiency':[], 'reliability':[], 'functionality':[], 'usability':[], 'maintainability':[]}
    for q in quality_map.keys():
        q_file = open(exp + 'wordlist.' + q)
        for line in q_file:
            quality_map[q].append(line.rstrip())
    return quality_map
    
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
    return annotations, thresh_el
    
def index_matching_wordlists(thresh_el, annotations, quality_map):
    """"""
    el_results = {}
    anno_results = []
    count = 0
    for quality in quality_map.keys():
        for keyword in quality_map[quality]:
            if keyword in thresh_el:
                count = count + 1 #count of occurences for that quality's keywords
        # assign the count to that quality
        el_results[quality] = count
        count = 0
    matches = [x for x in el_results.keys() if el_results[x] > 0]  # only print matches   
    overlap = False      
    # this was a little hard to read
    #overlap = len([ m for m in matches if m in annotations ]) > 0 or \
    #           (len(annotations) > 0 and annotations[0] == 'none')
    # We want to check if there no annotations or it was annotated NONE
    # then we want to check if matches overlaps ok?
    # i have no clue why none and zip for annotations means anything
    if (len(annotations) == 0):
        overlap = True
    elif ("none" in annotations):
        overlap = True
    else:
        overlap = len([m for m in matches if m in annotations]) > 0

    #for m in matches:
    #    if m in annotations or (len(annotations) > 0 and annotations[0] == 'none'):
    #        overlap = True
    # the script used to print here.
    if overlap:
        return 'yes'
    else:
        return "no match"

def compare_results():
    """"""
    # Create a list of annotations indexed to period/topic.
# Compare the annotation qualities per period/topic to the list generated by lda.


# The main for this program
# load up periods per project
# and the write out if a project
if __name__ == '__main__':
    maxdb_periods = ["1088563753", "1098931753",   "1119667753",  "1132627753",  "1142995753", 
                    "1091155753",  "1101523753",  "1122259753",  "1135219753",  "1145587753", 
                    "1093747753",  "1104115753",  "1124851753",  "1137811753",  "1148179753", 
                    "1096339753",  "1106707753",  "1130035753",  "1140403753",  "1150771753"]
    mysql_periods = ["965099404" ,"967691404" ,"970283404" ,"972875404" ,"975467404" ,"978059404" ,"980651404" ,"983243404" ,"985835404" ,"988427404" ,"991019404" ,"993611404" ,"996203404" ,"998795404" ,"1001387404" ,"1003979404" ,"1006571404" ,"1009163404" ,"1011755404" ,"1014347404" ,"1016939404" ,"1019531404" ,"1022123404" ,"1024715404" ,"1027307404" ,"1029899404" ,"1032491404" ,"1035083404" ,"1037675404" ,"1040267404" ,"1042859404" ,"1045451404" ,"1048043404" ,"1050635404" ,"1053227404" ,"1055819404" ,"1058411404" ,"1061003404" ,"1063595404" ,"1066187404" ,"1068779404" ,"1071371404" ,"1073963404" ,"1076555404" ,"1079147404" ,"1081739404" ,"1084331404" ,"1086923404" ,"1089515404" ,"1092107404"]
    maxdb_dir = "data/maxdb-tagged/"
    mysql_dir = "data/mysql-tagged/"
    exps = [ ["maxdb",maxdb_dir, maxdb_periods] , [ "mysql",mysql_dir, mysql_periods ] ]
    # test_period = '1098931753'
    #     topics = load_period(test_period)
    quality_map = load_wordlists()
    for exp in exps:
        dir = exp[1]
        periods = exp[2]
        report = exp[0]
        report_file = report + ".report.txt"
        rfile = open( report_file, "w" )
        print report
        rfile.write(report+'\n')
        for period in periods:
          pstr = "Period #" + period
          print pstr
          rfile.write(pstr+'\n')
          topics = load_period(period, data_dir = dir)
          for t in topics:
              annotations, thresh_el = create_element_list(t)
              res = index_matching_wordlists(thresh_el, annotations, quality_map)
              print res
              rfile.write(res+'\n')
        rfile.close()

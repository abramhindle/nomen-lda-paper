
def word_list_exps():
    return [ 'exp'+str(x) for x in [1,2,3]]

def word_list_dir( wln ):
    return '../' + str( wln ) + '/'

def word_list_dirs():
    return [ word_list_dir(x) for x in word_list_exps()]

def get_exps():
    maxdb_periods = ["1088563753", "1098931753",   "1119667753",  "1132627753",  "1142995753", 
                     "1091155753",  "1101523753",  "1122259753",  "1135219753",  "1145587753", 
                     "1093747753",  "1104115753",  "1124851753",  "1137811753",  "1148179753", 
                     "1096339753",  "1106707753",  "1130035753",  "1140403753",  "1150771753"]
    mysql_periods = ["965099404" ,"967691404" ,"970283404" ,"972875404" ,"975467404" ,"978059404" ,
                     "980651404" ,"983243404" ,"985835404" ,"988427404" ,"991019404" ,"993611404" ,
                     "996203404" ,"998795404" ,"1001387404" ,"1003979404" ,"1006571404" ,"1009163404" ,
                     "1011755404" ,"1014347404" ,"1016939404" ,"1019531404" ,"1022123404" ,"1024715404" ,
                     "1027307404" ,"1029899404" ,"1032491404" ,"1035083404" ,"1037675404" ,"1040267404" ,
                     "1042859404" ,"1045451404" ,"1048043404" ,"1050635404" ,"1053227404" ,"1055819404" ,
                     "1058411404" ,"1061003404" ,"1063595404" ,"1066187404" ,"1068779404" ,"1071371404" ,
                     "1073963404" ,"1076555404" ,"1079147404" ,"1081739404" ,"1084331404" ,"1086923404" ,
                     "1089515404" ,"1092107404"]
    pgsql_periods = ["1013163667", "1020939667", "1028715667", "1036491667", "1044267667", 
                     "1052043667", "1059819667", "1067595667", "1075371667", "1083147667", 
                     "1090923667", "1015755667", "1023531667", "1031307667", "1039083667", 
                     "1046859667", "1054635667", "1062411667", "1070187667", "1077963667", 
                     "1085739667", "1093515667", "1018347667", "1026123667", "1033899667", 
                     "1041675667", "1049451667", "1057227667", "1065003667", "1072779667", 
                     "1080555667", "1088331667"]
    
    maxdb_dir = "../../data/maxdb-tagged/"
    mysql_dir = "../../data/mysql-tagged/"
    pg_dir = "../../data/pgsql-tagged/"

    exprs = [ ["maxdb",maxdb_dir, maxdb_periods] , [ "mysql",mysql_dir, mysql_periods ], ["pgsql",pg_dir, pgsql_periods]]
    return exprs

__exp1_wordlist__ = [
"accuracy", "availability", "correctness", "efficiency", "flexibility", "integrity", "interoperability", "maintainability", "modifiability", "modularity", "performance", "portability", "reliability", "security", "testability", "traceability", "understandability", "usability", "verifiability"]

"""NFRs for EXP2 and EXP3"""
__exp2_wordlist__ = ['portability', 'efficiency', 'reliability', 'functionality', 'usability', 'maintainability']
    
"""Look up table of wordlists for exp1..exp3"""
__word_lists__ = {
    'exp1':__exp1_wordlist__,
    'exp2':__exp2_wordlist__,
    'exp3':__exp2_wordlist__,
}

def gen_exp_wordlist_quality_map( exp ):
    """ Given an expirement return its wordlist's quality map  """
    l = __word_lists__[exp]
    h = {}
    for x in l:
        h[x] = []
    return h

 
def load_wordlists(exp = 'exp3' ): 
    """ load the datafile with the wordlists we want to use """
    quality_map = gen_exp_wordlist_quality_map( exp )
    # {'portability':[], 'efficiency':[], 'reliability':[], 'functionality':[], 'usability':[], 'maintainability':[]}
    expdir = word_list_dir( exp )
    for q in quality_map.keys():        
        q_file = open( expdir + 'wordlist.' + q )
        for line in q_file:
            quality_map[ q ].append( line.rstrip() )
    return quality_map


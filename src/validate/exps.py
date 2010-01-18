gdef get_exps():
    maxdb_periods = ["1088563753", "1098931753",   "1119667753",  "1132627753",  "1142995753", 
                    "1091155753",  "1101523753",  "1122259753",  "1135219753",  "1145587753", 
                    "1093747753",  "1104115753",  "1124851753",  "1137811753",  "1148179753", 
                    "1096339753",  "1106707753",  "1130035753",  "1140403753",  "1150771753"]
    mysql_periods = ["965099404" ,"967691404" ,"970283404" ,"972875404" ,"975467404" ,"978059404" ,"980651404" ,"983243404" ,"985835404" ,"988427404" ,"991019404" ,"993611404" ,"996203404" ,"998795404" ,"1001387404" ,"1003979404" ,"1006571404" ,"1009163404" ,"1011755404" ,"1014347404" ,"1016939404" ,"1019531404" ,"1022123404" ,"1024715404" ,"1027307404" ,"1029899404" ,"1032491404" ,"1035083404" ,"1037675404" ,"1040267404" ,"1042859404" ,"1045451404" ,"1048043404" ,"1050635404" ,"1053227404" ,"1055819404" ,"1058411404" ,"1061003404" ,"1063595404" ,"1066187404" ,"1068779404" ,"1071371404" ,"1073963404" ,"1076555404" ,"1079147404" ,"1081739404" ,"1084331404" ,"1086923404" ,"1089515404" ,"1092107404"]
    maxdb_dir = "data/maxdb-tagged/"
    mysql_dir = "data/mysql-tagged/"
    exprs = [ ["maxdb",maxdb_dir, maxdb_periods] , [ "mysql",mysql_dir, mysql_periods ] ]
    return exprs
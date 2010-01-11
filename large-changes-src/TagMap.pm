# I extracted our tags with get_tags
package TagMap;
use strict;
#I am giving these symbolic names so we can get
#spell-checked/type checked

my $IGNORE = undef;
my $add_module = "Add Module";
#my $add_dir = "Add Directory";
my $add_dir = $add_module;
my $branch = "Branch";
my $bug = "Bug";
my $build = "Build";
my $cln = "Cleanup";
my $license = "Legal";
my $copyright = $license;
my $cross = "Cross cutting concern";
my $data = "Data";
my $dbg = "Debug";
my $fdel = "File Delete";
my $doc = "Documentation";
my $ext = "External Submission";
my $fea = "Feature Addition";
my $indent = "Indentation and Whitespace";
my $init = "Module Initalization";
my $intl = "Internationalization";

my $scs = "Source Control System";
my $fil = $scs;# "File Management";


my $maintenance = "Maintenance";
my $merge = "Merge";

my $int = $merge; #"Integration";

my $mmod = "Module Move";
my $mntn = "Maintenance";
my $platform = "Platform Specific";
my $remove_module = "Remove Module";
#my $remove_dir = "Remove Directory";
my $remove_dir = $remove_module;
my $ren = "Rename";
my $refactor = "Refactor";
my $test = "Test";
my $unk = "Unknown";
my $split = "Split Module";
my $trpl = "Token Replace";
my $versioning = "Versioning";
my $cleanup = $cln;
my $token = "Token Replacement";

{
	my %module_map = (
		'add'		=> $add_module,
		'adir'		=> $add_dir,
		'branch'	=> $branch,
		'brch'		=> $branch,
		'brnch'		=> $branch,
		'bug'		=> $bug,
		'bui'		=> $build,
		'cln'		=> $cleanup,
		'copyright'	=> $license,
		'cross'		=> $cross,
		'data'		=> $data,
		'dbg'		=> $dbg,
		'del'		=> $IGNORE,#$fdel,
		'delete'	=> $IGNORE,#$fdel,
		'doc'		=> $doc,
		'ext'		=> $ext,
		'fadd'		=> $IGNORE,
		'fdel'		=> $IGNORE,#$fdel,
		'fea'		=> $fea,
		'fi'		=> $fil,
		'fil'		=> $fil,
		'fix'		=> $bug,
		'ident'		=> $indent,
		'ind'		=> $indent,
		'indent'	=> $indent,
		'init'		=> $init,
		'int'		=> $int,
		'intl'		=> $intl,
		'lic'		=> $license,
		'log'		=> $scs,
		'maint'		=> $maintenance,
		'merge'		=> $merge,
		'mmod'		=> $mmod,
		'mntn'		=> $mntn,
		'mrg'		=> $merge,
		'plat'		=> $platform,
		'rdir'		=> $remove_dir,
		'ren'		=> $ren,
		'rfact'		=> $refactor,
		'rfc'		=> $refactor,
		'rfcg'		=> $refactor,
		'rfct'		=> $refactor,
		'rmod'		=> $remove_module,
		'scs'		=> $scs,
		'split'		=> $split,
		'test'		=> $test,
		'trpl'		=> $token,
		'tst'		=> $test,
		'unk'		=> $unk,
		'ver'		=> $versioning,
	);
	sub first_map {
            my $inp = $_[0];
            if (exists $module_map{$inp}) {
                return $module_map{$inp};
            } else {
                return undef;
            }
	}
	sub first_mapping {
            return %module_map;
	}
	sub first_tags {
            my %H = reverse %module_map;
            return (grep { $_ } (keys %H));
	}
}

my $file = "File Management";
my $module = "Module Management";
my $source_control = "SCS Management";
my $meta = "Meta-Program";
my $implementation = "Implementation";
my $nonfunctionalcode = "Non-functional Code";
{
	my %first_abram_grouping = (
                                    
	#FILE STUFF -> Module Management
	   $add_dir 	=> $module,#$file,
	   $fdel 	=> $module,#$file,
	   $ren 	=> $module,#$file,
	   $remove_dir 	=> $module,#$file,
	#   $fil 	=> $file,
	
	#MODULE STUFF
	   $add_module 		=> $module,
	   $mmod 		=> $module,
	   $split 		=> $module,
	   $remove_module 	=> $module,
	   $init 		=> $module,
	
	#SCS STUFF & Sourcing
	   $branch 	=> $source_control,
	   $ext 	=> $source_control,
	   $merge 	=> $source_control,
	   $versioning 	=> $source_control,
	   $scs 	=> $source_control,
	
	#MAINTENANCE
	   $bug 	=> $maintenance,
	   #$cln 	=> $maintenance,
	   $dbg		=> $maintenance,
	   #$indent 	=> $maintenance,
	   #$refactor 	=> $maintenance,
	   #$trpl 	=> $maintenance,
	   $mntn 	=> $maintenance,
	   $maintenance => $maintenance,
	   $cross 	=> $maintenance,
	
	   $cln 	=> $nonfunctionalcode,
           $trpl 	=> $nonfunctionalcode,
           $refactor 	=> $nonfunctionalcode,
	   $indent 	=> $nonfunctionalcode,

	#IMPLEMENTATION & FEATURES
	   $fea 	=> $implementation,
	   $int 	=> $implementation,
	   $platform 	=> $implementation,
	
	#META PROGRAM, DOCS, BUILD, TEST
	   $build	=> $meta,
	   $test 	=> $meta,
	   $doc  	=> $meta,
	   $data 	=> $meta,
	   $intl 	=> $meta,
	
	#LICENSE
	   $license   => $license,
	   $copyright => $license,
	);
	#raw tag to this mapping here
	sub get_first_abram_grouping {
		my $k = $_[0];
		if (exists $first_abram_grouping{$k}) {
			return $first_abram_grouping{$k};
		}
		return undef;
	}
	sub first_abram_map {
		my $key = shift;
		return get_first_abram_grouping(first_map($key));
	}
	sub first_abram_tags {
		my %h = reverse %first_abram_grouping;
                return (grep {defined($_)} (keys %h));

	}
}

# From Swanson 76
my $corrective = "Corrective";
# Processing Failure
# Performance Failure
# Implementation Failure
my $perfective = "Perfective";
# Ineffeciency
# Enhancement
# Maintainability
my $adaptive = "Adaptive";
# Data Environment
# Processing Environment
my $implementation = "Implementation";
# Not maintenance
# File or SCS stuff
my $other = "Other";
# Non functional
my $nonfunctional = "Non Functional";
{
	my %swanson_map = (
	#FILE STUFF
	#We'll ignore file stuff
	   $add_dir 	=> $implementation, #other,
	   $fdel 	=> $perfective, #other,
	   $ren 	=> $perfective, #other,
	   $remove_dir 	=> $perfective, #other,
	#   $fil 	=> $other,
	
	#MODULE STUFF
	   $add_module 		=> $implementation,
	   $mmod 		=> $perfective,
	   $split 		=> $perfective,
	   $remove_module 	=> $perfective,
	   $init 		=> $implementation,
	
	#SCS STUFF & Sourcing
        # non functional
	   $branch 	=> $nonfunctional,
	   $ext 	=> $nonfunctional,
	   $versioning 	=> $nonfunctional,
	   $scs 	=> $nonfunctional,
	   #$merge 	=> $other, # I don't know!
	
	#MAINTENANCE
	   $bug 	=> $corrective,
	   $cln 	=> $perfective,
	   $dbg		=> $corrective,
	   $indent 	=> $perfective,
	   $refactor 	=> $perfective,
	   $trpl 	=> $nonfunctional, #I don't know
	   $mntn 	=> $perfective,
	   $maintenance => $perfective,
	   #$cross 	=> $other, #I don't know!
	
	#IMPLEMENTATION & FEATURES
	   $fea 	=> $implementation,
	   $int 	=> $implementation,
	   $platform 	=> $adaptive,
	
	#META PROGRAM, DOCS, BUILD, TEST
	   $build	=> $adaptive,
	   $test 	=> $adaptive,
	   $doc  	=> $adaptive,
	   $data 	=> $adaptive,
	   $intl 	=> $adaptive,
	
	#LICENSE
        #was other
	   $license   => $nonfunctional,#other
	   $copyright => $nonfunctional,#other
	);
	#raw tag to this mapping here
	sub swanson_get {
		my $k = shift;
		if (exists $swanson_map{$k}) {
			return $swanson_map{$k}; 
		} else {
                    undef
		}
	}
	sub swanson_map {
		my $key = shift;
	 	return swanson_get(first_map($key));
	}
	sub swanson_get_tags {
		my @tags = @_;
		my %h = ();
		foreach my $tag (@tags) {
			my $key = swanson_map($tag);
			$h{$key}++;
		}
		return keys %h;
	}
	sub swanson_tags {
            #my %h = reverse %swanson_map;
            #return keys %h;
            #return ($corrective, $adaptive, $perfective, $implementation, $nonfunctional, $other);
            return ($corrective, $adaptive, $perfective, $nonfunctional, $implementation);
        }
}

#Not a good one..

my $BUILD = "Build";
my $TEST = "Test";
my $DOC = "Documentation";
my $SRC = "Source Code";
my $DATA = "Data";
my $OTHER = "Other";
{
	my %stbd = (
	#FILE STUFF
	
	#MODULE STUFF
	
	#SCS STUFF & Sourcing
	
	#MAINTENANCE
	   $bug 	=> $SRC,
	   $cln 	=> $SRC,
	   $dbg		=> $SRC,
	   $indent 	=> $SRC,
	   $refactor 	=> $SRC,
	   $trpl 	=> $SRC,
	   $mntn 	=> $SRC,
	   $maintenance => $SRC,
	   $cross 	=> $SRC,

	
	#IMPLEMENTATION & FEATURES
	   $fea 	=> $SRC,
	   $int 	=> $SRC,
	   $platform 	=> $SRC,
	
	#META PROGRAM, DOCS, BUILD, TEST
	   $build	=> $BUILD,
	   $test 	=> $TEST,
	   $doc  	=> $DOC,

	   $data 	=> $DATA,
	   $intl 	=> $DATA,
	
	#LICENSE
	);
	#raw tag to this mapping here
	sub get_STBD {
		my $k = $_[0];
		if (exists $stbd{$k}) {
			return $stbd{$k};
		}
		return $OTHER; #UNDEF MEANS IGNORE
	}
	sub STBD_map {
		my $key = shift;
		return get_STBD(first_map($key));
	}
	sub STBD_tags {
		my %h = reverse %stbd;
                $h{$OTHER} = 1;
		return keys %h;
	}
}
our  $DETAIL = "detail";
our  $LARGE = "large";
our  $STBD = "STBD";
our  $SWANSON = "Swanson";

my $DETAIL_DESC = "Detailed Classes";
my $LARGE_DESC  = "Large Commit Classes";
my $STBD_DESC = "STBD Grouping";
my $SWANSON_DESC = "Extended Swanson Maintenance Classes";

sub tag_names {
    #my @a = ($DETAIL, $LARGE, $STBD, $SWANSON);
    my @a = ($SWANSON, $LARGE, $DETAIL, $STBD);
    return @a;
}

{
    my %base =($DETAIL => $DETAIL_DESC,
               $LARGE => $LARGE_DESC,
               $STBD => $STBD_DESC,
               $SWANSON => $SWANSON_DESC,
             );

    sub tag_map {
        my %h = %base;
        return $h{$_[0]};
    }
    sub title_of {
        my %h = 
            (
             %base,
             $DETAIL_DESC => "Types of Commits",
             $LARGE_DESC => $LARGE_DESC,
             $STBD_DESC  => $STBD_DESC,
             $SWANSON_DESC => $SWANSON_DESC,
             );
        return $h{$_[0]};
    }
}



sub get_map_fun_for {
    my $group = $_[0];
    my %h = 
        ($DETAIL => \&first_map,
         $LARGE => \&first_abram_map,
         $STBD => \&STBD_map,
         $SWANSON => \&swanson_map,
         );
    return $h{$group};
}

sub get_tags_fun_for {
    my $group = $_[0];
    my %h = 
        ($DETAIL => \&first_tags,
         $LARGE => \&first_abram_tags,
         $STBD => \&STBD_tags,
         $SWANSON => \&swanson_tags,
         );
    return $h{$group};
}


sub get_tags_for {
    my $group = $_[0];
    my $fun = get_tags_fun_for($group);
    if (!$fun) {
        die "$group -> get_tags_for failed";
    }
    return &$fun();
}

sub get_project_name {
    my $everything = "Union of all projects";
    my %h = (
             "boost"	             => "Boost",
             "egroupware"            => "EGroupware",
             "enlightenment"         => "Enlightenment",
             "evolution"             => "Evolution",
             "firebird"              => "Firebird",
             "mysql-5_0"             => "MySQL 5.0",
             "postgresql"            => "PostgreSQL",
             "samba"                 => "Samba",
             "springframework"       => "Spring Framework",
             "Everything"            => $everything,
             "everything"            => $everything,
             );
    return $h{$_[0]};
}
sub get_tag_function_tuples {
    return map {
        my $tag = $_;
        [$tag , get_map_fun_for($tag) , get_tags_fun_for($tag)]
        } ( tag_names() );
    #return 
    #(
    # ["our",\&TagMap::first_map, \&TagMap::first_tags],
    # ["grouping",\&TagMap::first_abram_map, \&TagMap::first_abram_tags],
    # ["Swanson",\&TagMap::swanson_map, \&TagMap::swanson_tags],
    # ["STBD",\&TagMap::STBD_map, \&TagMap::STBD_tags],
    # );
}

{
    my %base =($DETAIL => "Detailed",
               $LARGE => "Large Commits",
               $STBD => "STBD",
               $SWANSON => "Ext. Swanson",
              );
    sub get_short_tag_name {
        return $base{$_[0]};
    }
}


1;


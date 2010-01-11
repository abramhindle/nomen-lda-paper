#unsupported
#evolution
#mysql-5_0
#postgresql

for file in boost egroupware enlightenment  firebird samba springframework
do
    echo perl convert-abez-style-to-second.pl $file/markup_report $file/markup_report.orig $file/dir
done
echo perl convert-abez-style-to-second.pl mysql-5_0/hacked/markup_report mysql-5_0/hacked/markup_report.orig mysql-5_0/dir
echo perl convert-abez-style-to-second.pl evolution/hacked/markup_report evolution/hacked/markup_report.orig evolution/dir
echo perl convert-abez-style-to-second.pl postgresql/hacked/markup_report postgresql/hacked/markup_report.orig postgresql/dir

for file in boost egroupware enlightenment  firebird samba springframework
do
    echo perl convert-abez-style-to-second.pl -bigtype $file/markup_report $file/markup_report.orig $file/big
done
echo perl convert-abez-style-to-second.pl -bigtype mysql-5_0/hacked/markup_report mysql-5_0/hacked/markup_report.orig mysql-5_0/big
echo perl convert-abez-style-to-second.pl -bigtype evolution/hacked/markup_report evolution/hacked/markup_report.orig evolution/big
echo perl convert-abez-style-to-second.pl -bigtype postgresql/hacked/markup_report postgresql/hacked/markup_report.orig postgresql/big

for file in boost egroupware enlightenment  firebird samba springframework
do
    echo perl convert-abez-style-to-second.pl -bigtype -nomodules $file/markup_report $file/markup_report.orig $file/wauthor
done
echo perl convert-abez-style-to-second.pl -bigtype -nomodules mysql-5_0/hacked/markup_report mysql-5_0/hacked/markup_report.orig mysql-5_0/wauthor
echo perl convert-abez-style-to-second.pl -bigtype -nomodules evolution/hacked/markup_report evolution/hacked/markup_report.orig evolution/wauthor
echo perl convert-abez-style-to-second.pl -bigtype -nomodules postgresql/hacked/markup_report postgresql/hacked/markup_report.orig postgresql/wauthor

for file in boost egroupware enlightenment  firebird samba springframework
do
    echo perl convert-abez-style-to-second.pl -bigtype -noauthors $file/markup_report $file/markup_report.orig $file/noauthor
done
echo perl convert-abez-style-to-second.pl -bigtype -noauthors mysql-5_0/hacked/markup_report mysql-5_0/hacked/markup_report.orig mysql-5_0/noauthor
echo perl convert-abez-style-to-second.pl -bigtype -noauthors evolution/hacked/markup_report evolution/hacked/markup_report.orig evolution/noauthor
echo perl convert-abez-style-to-second.pl -bigtype -noauthors postgresql/hacked/markup_report postgresql/hacked/markup_report.orig postgresql/noauthor




for file in boost egroupware enlightenment  firebird samba springframework
do
    echo perl convert-abez-style-to-second.pl -nomodules $file/markup_report $file/markup_report.orig $file/onlyauthor
done
echo perl convert-abez-style-to-second.pl -nomodules mysql-5_0/hacked/markup_report mysql-5_0/hacked/markup_report.orig mysql-5_0/onlyauthor
echo perl convert-abez-style-to-second.pl -nomodules evolution/hacked/markup_report evolution/hacked/markup_report.orig evolution/onlyauthor
echo perl convert-abez-style-to-second.pl -nomodules postgresql/hacked/markup_report postgresql/hacked/markup_report.orig postgresql/onlyauthor


#no word distro
#no author
for file in boost egroupware enlightenment  firebird samba springframework
do
    echo perl convert-abez-style-to-second.pl  -noauthors $file/markup_report $file/markup_report.orig $file/onlydir
done
echo perl convert-abez-style-to-second.pl  -noauthors mysql-5_0/hacked/markup_report mysql-5_0/hacked/markup_report.orig mysql-5_0/onlydir
echo perl convert-abez-style-to-second.pl  -noauthors evolution/hacked/markup_report evolution/hacked/markup_report.orig evolution/onlydir
echo perl convert-abez-style-to-second.pl  -noauthors postgresql/hacked/markup_report postgresql/hacked/markup_report.orig postgresql/onlydir

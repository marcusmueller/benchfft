# script to initialize automake/autoconf etc
echo "Please ignore warnings and errors"
autoheader
aclocal
automake --add-missing
autoconf
autoheader
aclocal
automake --add-missing
autoconf

rm -f config.cache

./configure $*

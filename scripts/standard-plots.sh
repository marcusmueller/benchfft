#! /bin/sh

sd=`dirname $0`
case $sd in
    /*) ;;
    *) sd=`pwd`/$sd ;;
esac

data=$1
dname=`basename $data .speed`

for rank in 1 2 3; do
    for problem in dcxx drxx scxx scxx srxx; do
	for p2 in p2 np2; do
	    echo "${dname}.${rank}d.${problem}.${p2}.ps"
	    pat=`echo $problem | sed 's/xy/[io][fb]/g'`
	    (sh $sd/plot-title.sh $problem $rank $p2;
		egrep "$pat" $data | perl $sd/grep-rank.pl $rank |
		perl $sd/grep-${p2}.pl | perl $sd/grace-plot.pl --no-dups) |
		gracebat -pipe -printfile ${dname}.${rank}d.${problem}.${p2}.ps
	done
    done
done

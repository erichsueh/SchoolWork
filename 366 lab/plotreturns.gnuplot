plot "avgret.dat" using 1:2 ti ""
set title "Average return obtained by Double Q-learning after n-th episode"
set xlabel "Episode number (n)"
set ylabel "Average return"
set xrange [1:200]
set yrange [-100:-15000]
set terminal postscript eps enhanced color
set output "avgret.eps"
replot

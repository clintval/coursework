set terminal png tiny size 800,800
set output "promer_AE000511.1_vs_AE001439.1.png"
set size 1,1
set grid
unset key
set border 15
set tics scale 0
set xlabel "AE001439"
set ylabel "AE000511"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set mouse clipboardformat "[%.0f, %.0f]"
set xrange [0:1667867]
set yrange [0:1643831]
set style line 1  lt 1 lw 3 pt 6 ps 1
set style line 2  lt 3 lw 3 pt 6 ps 1
set style line 3  lt 2 lw 3 pt 6 ps 1
plot \
 "promer_AE000511.1_vs_AE001439.1.fplot" title "FWD" w lp ls 1, \
 "promer_AE000511.1_vs_AE001439.1.rplot" title "REV" w lp ls 2

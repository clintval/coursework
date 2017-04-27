set terminal png tiny size 800,800
set output "AE000511.1_vs_CP000241.1_mummer.png"
set size 1,1
set grid
unset key
set border 0
set tics scale 0
set xlabel "REF"
set ylabel "CP000241"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set mouse clipboardformat "[%.0f, %.0f]"
set xrange [0:1667867]
set yrange [0:1596366]
set style line 1  lt 1 lw 3 pt 6 ps 1
set style line 2  lt 3 lw 3 pt 6 ps 1
set style line 3  lt 2 lw 3 pt 6 ps 1
plot \
 "AE000511.1_vs_CP000241.1_mummer.fplot" title "FWD" w lp ls 1, \
 "AE000511.1_vs_CP000241.1_mummer.rplot" title "REV" w lp ls 2

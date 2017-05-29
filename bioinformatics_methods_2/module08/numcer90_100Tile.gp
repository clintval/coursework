set terminal png tiny size 800,800
set output "numcer90_100Tile.png"
set size 1,.375
set grid
unset key
set border 15
set tics scale 0
set xlabel "B_anthracis_Mslice"
set ylabel "%SIM"
set format "%.0f"
set mouse format "%.0f"
set mouse mouseformat "[%.0f, %.0f]"
set mouse clipboardformat "[%.0f, %.0f]"
set xrange [1:312600]
set yrange [90:100]
set style line 1  lt 1 lw 3
set style line 2  lt 3 lw 3
set style line 3  lt 2 lw 3 pt 6 ps 1
plot \
 "numcer90_100Tile.fplot" title "FWD" w l ls 1, \
 "numcer90_100Tile.rplot" title "REV" w l ls 2

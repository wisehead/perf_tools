set terminal png truecolor
set output "Innodb_data_pending_writes.png"
set autoscale
set grid
set title "Innodb_data_pending_writes"
set xlabel "VTime(s)"
set xlabel "data pending write"
set style data lines
sample=1
funx(x)=(sample * x)
plot "< grep 'Innodb_data_pending_writes' global_0.out |awk 'BEGIN{ i=0} {print i \" \" $2; i++};' " using (funx($1)) :2 lw 2 title "Innodb_data_pending_writes"

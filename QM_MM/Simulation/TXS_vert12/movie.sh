deltaC10=$(echo "0.034" | bc)
C10ini=$(echo "1.10" | bc)

deltaC6=$(echo "0.05" | bc)
C6ini=$(echo "5.15" | bc)

limit=82
n=1

[ -e md_total.mdcrd ] && rm md_total.mdcrd

while [ $n -le $limit ]
do
	C10r1=$(echo "$C10ini - $deltaC10*($n-1)" | bc )
	C6r1=$(echo "$C6ini - $delta*($n-1)" | bc )

	cpptraj -p TXS_vert12_ion.pmrtop <<eof
	trajin md$n.mdcrd
	trajout md_temp.mdcrd crd
	go

	eof

	cat md_temp.mdcrd >> md_total.mdcrd
	rm md_temp.mdcrd
	(( n++ ))
	done


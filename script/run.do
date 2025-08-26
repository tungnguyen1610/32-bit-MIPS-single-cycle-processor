vsim +access+r work.testbench   ;# change 'work.top' to your testbench top module
run -all                  ;# run simulation until completion
acdb save                 ;# save functional coverage database
acdb report -db fcover.acdb -txt -o cov.txt -verbose ;# generate cov.txt
exit
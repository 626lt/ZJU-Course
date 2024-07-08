rm -rf target
rm -rf result
mkdir target
mkdir result
make
cd target
touch data.txt
echo "check result in result folder"
./pdadd < ../test/add.txt # test pdadd
echo "add successcfully!"
./pdlist >> ../result/listresult0.txt # test pdlist without date
echo "list successcfully! check in listresult0.txt"
./pdlist 2023-12-7 2023-12-14 >> ../result/listresult1.txt # test pdlist with date
echo "list between date successcfully! check in listresult1.txt"
./pdlist | ./pdshow >> ../result/showresult.txt # test pdshow
echo "show successcfully! check in showresult.txt"
./pdremove < ../test/remove.txt # test pdremove
echo "perform remove!"
./pdlist | ./pdshow >> ../result/removeresult.txt # show result after remove
echo "remove successcfully! check in removeresult.txt"

DATE=$(date "+%Y%m%d")
filePath="/data/local/lib/bk/$DATE"
if [ ! -d $filePath ];then
	mkdir -p $filePath
fi
cd $filePath
mysqldump -uroot -pSd_12345 -h127.0.0.1 byrsjyzx > byrsjyzx.sql
mysqldump -uroot -pSd_12345 -h127.0.0.1 lcy > lcy.sql
mysqldump -uroot -pSd_12345 -h127.0.0.1 bysjybt > bysjybt.sql
mysqldump -uroot -pSd_12345 -h127.0.0.1 cyddjybt > cyddjybt.sql
mysqldump -uroot -pSd_12345 -h127.0.0.1 fund_management_system > fund_management_system.sql

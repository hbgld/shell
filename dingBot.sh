#!/bin/bash
# 钉钉机器人报警
# 请在企业内部钉钉群添加web-hook机器人，并修改URL及keyWord
URL="https://oapi.dingtalk.com/robot/send?access_token=xxxxxxxxxxxxxxxxxx"
keyWord="报警信息："


if [ $# -eq 0 ] || [[ "$1" == "-h" || "$1" == "--help" ]];then
	cat <<- eof
	使用方法: $(basename $0) --msg="MESSAGE" [--atall|--atPhone=PHONE|--atUser=USER]
	Options:
		--msg="MESSAGE"     消息内容
		--atall             @所有人
		--atPhone=PHONE     通过群内指定的手机号@指定用户
		--atUser=USER       通过用户名称@指定用户
		-h, --help          显示帮助信息
	eof
	exit
fi

! echo $* |grep -iq "msg" && echo "消息内容缺失，请使用--msg指定" && exit
atAll=false

for i in "$@";do
	egrep -iq "^(--atall|-a)$" <<< $i && atAll=true && continue
	grep -iq "msg" <<< $i  && msg=$(sed 's/.*=//' <<< $i) && msg="$keyWord\n$msg" && continue
	eval "$(echo $i|sed 's/--//')" &> /dev/null
done

info(){
	cat <<- eof
	{
	    "at": {
	        "atMobiles":[
	            "$atPhone"
	        ],
	        "atUserIds":[
	            "$atUser"
	        ],
	        "isAtAll": $atAll
	    },
	    "text": {
	        "content":"$msg"
	    },
	    "msgtype":"text"
	}
	eof
}
curl $URL -H "Content-Type: application/json" -d "$(info)"

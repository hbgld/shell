#!/bin/bash
# 企业微信机器人报警
# 请在内部企微群添加机器人，并修改以下URL
URL="https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxxxxxxxxxxxxx"

if [ $# -eq 0 ] || [[ "$1" == "-h" || "$1" == "--help" ]];then
	cat <<- eof
	使用方法: $(basename $0) --msg="MESSAGE" [--atall|--atPhone=PHONE1[,PHONE2...]|--atUser=USER1[,USER2...]]
	Options:
		--msg="MESSAGE"                消息内容
		--atall                        @所有人
		--atPhone=PHONE1,PHONE2,...    通过群内指定的手机号@指定用户
		--atUser=USER1,USER2,...       通过用户名称@指定用户
		-h, --help                     显示帮助信息
	eof
	exit
fi
#
! echo $* |grep -iq "msg" && echo "消息内容缺失，请使用--msg指定" && exit

for i in "$@";do
	egrep -iq "^(--atall|-a)$" <<< $i && atAll=@all && continue
	grep -iq "msg" <<< $i  && msg=$(sed 's/.*=//' <<< $i) && msg="$keyWord\n$msg" && continue
	eval "$(echo $i|sed 's/--//')" &> /dev/null
done

if [ -n "$atUser" ];then
	[ -n "$atAll" ] && atUser=$atUser,$atAll
	atUser=[$(sed -r 's/^|$/"/g;s/,/","/g' <<< $atUser)]
else
	atUser=[\"$atAll\"]
fi

if [ -n "$atPhone" ];then
	atPhone=[$(sed -r 's/^|$/"/g;s/,/","/g' <<< $atPhone)]
else
	atPhone=[\"\"]
fi

info(){
	cat <<- eof
	{
    	"msgtype": "text",
    	"text": {
        	"content": "$msg",
            "mentioned_list":$atUser,
            "mentioned_mobile_list":$atPhone
    	}
	}
	eof
}
curl $URL -H "Content-Type: application/json" -d "$(info)"

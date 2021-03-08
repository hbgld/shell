#!/bin/bash 
# Wechat alert script for zabbix
if [ $# -eq 0 ] || [[ "$1" == "-h" || "$1" == "--help" ]];then
	cat <<- eof
	Usage of $(basename $0):
	  --CorpID=string    企业ID
	  --Secret=string    应用secret
	  --AgentID=string   应用AgentID
	  --UserID=string    用户ID,如果要发给多个用户,使用","隔开
	  --Msg="string"     信息内容
	eof
	exit
fi

for i in "$@";do
	echo $i|grep Msg &> /dev/null && msg=$(echo $i|sed 's/.*=//') && Msg="$msg" && continue
	eval "$(echo $i|sed 's/--//')"
done
UserID=$(sed 's/,/|/' <<< $UserID)

GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CorpID&corpsecret=$Secret"
Token=$(/usr/bin/curl -s -G $GURL |awk -F \" '{print $10}')
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Token"
INFO(){
	cat <<- eof
	{
	    "touser" : "$UserID",
	    "msgtype" : "text",
	    "agentid" : $AgentID,
	    "text" : {
	        "content" : "$Msg"
	    },
	    "safe":0
	}
	eof
}

/usr/bin/curl --data-ascii "$(INFO)" $PURL
echo

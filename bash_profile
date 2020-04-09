ipinfo(){
curl http://ipinfo.io/$1 | tee -a $2
}

fuzz(){
gobuster dir -u $1 -w $2 --wildcard | grep -e "Status: 200"
}

port(){
nmap -iL $1 -T5 -oA $2
}

status(){
whatweb -i $1 | grep -e 200 | awk '{print$1}' | tee -a $2 | wc -l
}

wayback(){
cat $1 | waybackurls | grep -v -e jpg -e png -e gif -e woff -e woff2 -e ttf -e svg -e jpeg -e css -e ico -e eot | tee -a $2 | wc -l
}

s3ls(){
aws s3 ls s3://$1
}

s3cp(){
aws s3 cp $2 s3://$1
}

abort(){
service ssh stop && poweroff
}

launch(){
service ssh start && ifconfig
}

b64d(){
echo $1 | base64 -d
}

b64e(){
echo $1 | base64
}

sub(){
python /root/tools/Sublist3r/sublist3r.py -d $1 -o $2 | wc -l
}

sub3(){
cat $1 | grep -Po "(\w+\.\w+\.\w+)$" | sort -u | tee -a $2 | wc -l
}

subloop(){
for domain in $(cat $1); do sublist3r -d $domain -o third-stage-domains.txt; cat third-stage-domains.txt |  sort -u >> final-subs.txt;done
}

alive(){
cat $1 | sort -u | httprobe -s -p https:443 | sed 's/https\?/\///' | tr -d ":443" | tee -a $2 | wc-l
}

ss(){
eyewitness -f $1 -d $2 --all-protocols && mv /usr/share/eyewitness/$2 $3
}

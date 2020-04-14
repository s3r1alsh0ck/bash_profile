export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

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
cat $1 | waybackurls | grep -v -e jpg -e png -e gif -e woff -e woff2 -e ttf -e svg -e jpeg -e css -e ico -e eot | sort -u | tee -a $2 | wc -l
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
python /root/tools/Sublist3r/sublist3r.py -d $1 -o $2
}

sub3(){
cat $1 | grep -Po "(\w+\.\w+\.\w+)$" | sort -u | tee -a $2 | wc -l
}

probe(){
cat $1 | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" | tee -a $2 | wc -l
}

ep(){
cat $1 | sort -u | httprobe -s -p https:443 | tr -d ":443" | tee -a http.txt
}

eye(){
eyewitness -f $1 --prepend-https --web
}

subloop(){
for domain in $(cat $1); do sublist3r -d $domain -o third-stage-domains.txt; cat third-stage-domains.txt |  sort -u >> final-subs.txt | rm third-stage-domains.txt;done
}

df(){
for domain in $(cat $1); do gobuster dir -u $domain -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt --wildcard -o df1.txt; cat df1.txt | grep -e "Status: 200" >> final.txt >> df.txt | rm df1.txt final.txt;done
}

ff(){
for domains in $(cat $1); do gobuster dir -u $domains -w /usr/share/seclists/Discovery/Web-Content/raft-medium-files.txt --wildcard -o ff1.txt; cat ff1.txt | grep -e "Status: 200" >> files.txt >>ff.txt | rm ff1.txt files.txt;done
}

subloop1(){
for domain in $(cat $1); do sublist3r -d $domain -o fourth-stage-domains.txt; cat fourth-stage-domains.txt |  sort -u >> final-subs.txt | rm fourth-stage-domains.txt;done
}

sub4(){
cat $1 | grep -Po "(\w+\.\w+\.\w+\.\w+)$" | sort -u | tee -a $2 | wc -l
}

formation(){
cat http.txt | grep -e cloud >> cloud.domain.txt;
cat http.txt | grep -e buy >> buy.domain.txt;
cat http.txt | grep -e api >> api.domain.txt;
cat http.txt | grep -e login >> login.domain.txt;
cat http.txt | grep -e corp >> corp.domain.txt;
cat http.txt | grep -e connect >> connect.domain.txt;
cat http.txt | grep -e dev >> dev.domain.txt;
cat http.txt | grep -e git >> git.domain.txt;
cat http.txt | grep -e vpn >> vpn.domain.txt;
cat http.txt | grep -e waf >> waf.domain.txt;
cat http.txt | grep -e mail >> mail.domain.txt;
cat http.txt | grep -v -e cloud -e buy -e api -e login -e corp -e connect -e dev -e git -e vpn -e waf -e mail >> rest.d
omain.txt
}

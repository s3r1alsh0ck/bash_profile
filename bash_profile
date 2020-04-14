export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
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
cat $1 | waybackurls | grep -v -e jpg -e png -e gif -e woff -e woff2 -e ttf -e svg -e jpeg -e css -e ico -e eot | sort -u | tee -a wayback.txt | wc -l
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
cat $1 | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ":443" | tee -a alive.txt | wc -l
}

ep(){
cat $1 | sort -u | httprobe -s -p https:443 | tr -d ":443" | tee -a http.txt
}

eye(){
./../../../tools/EyeWitness/Python/EyeWitness.py -f $1 --prepend-https --web
}

loopdomain(){
echo "1.sublist3r"
echo "2.subfinder"
echo "3.findimain"
echo "4.certspotter"

echo "Select a script to loop!"
read n

if [ $n == 1 ];
then
 echo "Looping with sublist3r!"
 for domain in $(cat $1); do python /root/tools/Sublist3r/sublist3r.py -d $domain -o more.subdomains.txt;done
 echo
 echo "Done with looping!"
fi

if [ $n == 2 ];
then
 echo "Looping with subfinder!"
 for domain in $(cat $1); do subfinder -d $domain -t 100 -o more.subdomains.txt;done
 echo
 echo "Done with looping!"
fi

if [ $n == 3 ];
then
 echo "Looping with findomain!"
 for domain in $(cat $1); do findomain -t $domain -u more.subdomains.txt;done
 echo
 echo "Done with looping!"
fi

if [ $n == 4 ];
then
 echo "Looping with certspotter!"
 for domain in $(cat $1); do curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $domain | tee -a more.su
bdomains.txt;done
 echo
 echo "Done with looping!"
fi
}

formation(){
cat $1 | grep -e cloud | awk -F "//" '{print $2}' >> cloud.domain.txt;
cat $1 | grep -e buy | awk -F "//" '{print $2}' >> buy.domain.txt;
cat $1 | grep -e api | awk -F "//" '{print $2}' >> api.domain.txt;
cat $1 | grep -e login | awk -F "//" '{print $2}' >> login.domain.txt;
cat $1 | grep -e corp | awk -F "//" '{print $2}' >> corp.domain.txt;
cat $1 | grep -e connect | awk -F "//" '{print $2}' >> connect.domain.txt;
cat $1 | grep -e dev | awk -F "//" '{print $2}' >> dev.domain.txt;
cat $1 | grep -e git | awk -F "//" '{print $2}' >> git.domain.txt;
cat $1 | grep -e vpn | awk -F "//" '{print $2}' >> vpn.domain.txt;
cat $1 | grep -e waf | awk -F "//" '{print $2}' >> waf.domain.txt;
cat $1 | grep -e mail | awk -F "//" '{print $2}' >> mail.domain.txt;
cat $1 | grep -v -e cloud -e buy -e api -e login -e corp -e connect -e dev -e git -e vpn -e waf -e mail | awk -F "//" '{print $2}' >> rest.domain.txt
}

domainenum(){
echo "Staring subdomain enumeration"
echo
findomain -t $1 -u sub.txt
echo
curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1 | tee -a sub.txt
echo
subfinder -d $1 -o sub.txt
echo
python /root/tools/Sublist3r/sublist3r.py -d $1 -o sub.txt
echo
cat sub.txt | sort -u | sed 's/<.*//' > subdomains.txt
echo
rm sub.txt
cat subdomains.txt | wc -l
}

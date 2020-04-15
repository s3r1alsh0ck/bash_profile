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

subfuzz(){
echo "Hey there"
echo "Input type: "
echo "1.Domain [Ex: domain.com]"
echo "2.File [Ex: domains_list.txt]"
read n

if [ $n == 1 ];
then
 echo "Staring subdomain enumeration"
 echo
 findomain -t $1 -u sub.txt
 echo
 curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1 | tee -a sub.txt
 echo
 subfinder -d $1 -o sub.txt
 echo
 python /root/Sublist3r/sublist3r.py -d $1 -o sub.txt
 echo
 cat sub.txt | sort -u | sed 's/<.*//' > subdomains.txt
 echo
 rm sub.txt
 echo "Output file is saved in /root/subdomains.txt and the file count is: "
 cat subdomains.txt | wc -l
fi

if [ $n == 2 ];
then
 echo "1.sublist3r"
 echo "2.subfinder"
 echo "3.findimain"
 echo "4.certspotter"
 echo "5.All the above.[This takes lot of time!!!]"
 sleep 2
 echo "Select a script to loop!"
 read n

if [ $n == 1 ];
then
 echo "Looping with sublist3r!"
 for domain in $(cat $1); do python /root/Sublist3r/sublist3r.py -d $domain -o more.subdomains.txt;done
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
 for domain in $(cat $1); do curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $d
omain | tee -a more.subdomains.txt;done
 echo
 echo "Done with looping!"
fi

if [ $n == 5 ];
then
 echo "Looping with all the above scripts!!!"
 for domain in $(cat $1); do python /root/tools/Sublist3r/sublist3r.py -d $domain -o more.subdomains.txt;done
 for domain in $(cat $1); do subfinder -d $domain -t 100 -o more.subdomains.txt;done
 for domain in $(cat $1); do findomain -t $domain -u more.subdomains.txt;done
 for domain in $(cat $1); do curl -s https://certspotter.com/api/v0/certs\?domain\=$domain | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $d
omain | tee -a more.subdomains.txt;done
 echo
 echo "Done with looping!!!!!"
fi
fi
echo "Output is saved in /root/"
}

classify(){
echo "classification process: "
echo "1.classify domains by subdomains output!!"
echo "2.clssify domains by httprobe output!!"
read n

if [ $n == 1 ];
then
 cat $1 | grep -e cloud >> cloud.domain.txt;
 cat $1 | grep -e buy >> buy.domain.txt;
 cat $1 | grep -e api >> api.domain.txt;
 cat $1 | grep -e login >> login.domain.txt;
 cat $1 | grep -e corp >> corp.domain.txt;
 cat $1 | grep -e connect >> connect.domain.txt;
 cat $1 | grep -e dev >> dev.domain.txt;
 cat $1 | grep -e git >> git.domain.txt;
 cat $1 | grep -e vpn >> vpn.domain.txt;
 cat $1 | grep -e waf >> waf.domain.txt;
 cat $1 | grep -e mail >> mail.domain.txt;
 cat $1 | grep -v -e cloud -e buy -e api -e login -e corp -e connect -e dev -e git -e vpn -e waf -e mail >> rest.domain.txt
echo "done"
fi

if [ $n == 2 ];
then
 cat $1 | grep -e cloud | sort -u | awk -F "//" '{print $2}' >> cloud.domain.txt;
 cat $1 | grep -e buy | sort -u | awk -F "//" '{print $2}' >> buy.domain.txt;
 cat $1 | grep -e api | sort -u | awk -F "//" '{print $2}' >> api.domain.txt;
 cat $1 | grep -e login | sort -u | awk -F "//" '{print $2}' >> login.domain.txt;
 cat $1 | grep -e corp | sort -u | awk -F "//" '{print $2}' >> corp.domain.txt;
 cat $1 | grep -e connect | sort -u | awk -F "//" '{print $2}' >> connect.domain.txt;
 cat $1 | grep -e dev | sort -u | awk -F "//" '{print $2}' >> dev.domain.txt;
 cat $1 | grep -e git | sort -u | awk -F "//" '{print $2}' >> git.domain.txt;
 cat $1 | grep -e vpn | sort -u | awk -F "//" '{print $2}' >> vpn.domain.txt;
 cat $1 | grep -e waf | sort -u | awk -F "//" '{print $2}' >> waf.domain.txt;
 cat $1 | grep -e mail | sort -u | awk -F "//" '{print $2}' >> mail.domain.txt;
 cat $1 | grep -v -e cloud -e buy -e api -e login -e corp -e connect -e dev -e git -e vpn -e waf -e mail | sort -u | awk -F "//" '{print $2}' >> rest.domain.txt
 echo "Done"
fi
}


fuzzer(){
if ! [ -x "$(command -v gobuster)" ]; then
    echo "installing gobuster"
    go get github.com/OJ/gobuster
fi
echo "Enter the path of your SecLists:  [ex: /root/SecLists]"
read d
if [ -d $d ]
then
    echo Directory $d exists.
else
    echo Error: Directory $d does not exists.
fi

if [ $d == /root/SecLists ];
then
 echo "All good"
else
    cp -r $d /root/
fi

echo "What you want to Fuzz"
echo "1.Fuzz the domains in a file. [ex: domains_list.txt]"
echo "2.Fuzz a domain. [ex: domain.com]"
read l
if [ $l == 1 ];then
echo "Choose the way you want to fuzz: "
echo
echo "1.Custom wordlist! [Enter the wordlist path when asked!]"
echo "2.Deafult wordlist! [I had a bunch for you!]"
echo
echo "0.Fuzz with custom wordlist"
echo "1.Fuzz basic wordlist count --> 4652 "
echo "2.Fuzz medium wordlist of directories count --> 30000 "
echo "3.Fuzz large wordlist of directories count --> 62275 "
echo "4.Fuzz medium wordlist of files count --> 17128 "
echo "5.Fuzz large wordlist of files count --> 37042 "
echo "6.Fuzz api wordlist found during recon count --> 7615 "
echo "7.Fuzz api wordlist common path count --> 33 "
echo "8.Fuzz api wordlist for actions count --> 222 "
echo "9.FUzz apache basic wordlist count --> 8531 "
echo "10.Fuzz frontend wordlist count --> 43 "
echo "11.Fuzz Php wordlist count --> 104 "
echo "12.Fuzz burp-parameter-names wordlist count --> 2588 "
echo "13.Fuzz graphql wordlist count --> 12 "
echo
echo "14.Fuzz with all the above wordlists!!!"
echo "Select a wordlist to fuzz: "
read n

if [ $n == 0 ];
then
 echo "Fuzzing with custom wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w $2 --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 1 ];
then
 echo "Fuzzing with basic wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/common.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 2 ];
then
 echo "Fuzzing with medium wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/raft-medium-directories.txt --wildcard | grep -e "Status: 200" >> $1.txt;d
one
 echo
 echo "Done with fuzzing"
fi

if [ $n == 3 ];
then
 echo "Fuzzing with large wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/raft-large-directories.txt --wildcard | grep -e "Status: 200" >> $1.txt;do
ne
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 4 ];
then
 echo "Fuzzing with medium size files wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/raft-medium-files.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 5 ];
then
 echo "Fuzzing with large size files wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/raft-large-files.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 6 ];
then
 echo "Fuzzing with api's found during recon wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/api/api-seen-in-wild.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 7 ];
then
 echo "Fuzzing with api's common-path wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/api/common_paths.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 8 ];
then
 echo "Fuzzing with api's action wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/api/actions.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 9 ];
then
 echo "Fuzzing with apache basic wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/Apache.fuzz.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 10 ];
then
 echo "Fuzzing with frontend wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/frontpage.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 11 ];
then
 echo "Fuzzing with PHP wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/PHP.fuzz.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 12 ];
then
 echo "Fuzzing with burp-parameter-names wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/burp-parameter-names.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 13 ];
then
 echo "Fuzzing with graphql wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/graphql.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 14 ];
then
 echo "Fuzzing with all wordlist!!"
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/common.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/raft-medium-directories.txt --wildcard | grep -e "Status: 200" >> $1.txt;d
one
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/raft-large-directories.txt --wildcard | grep -e "Status: 200" >> $1.txt;do
ne
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/raft-medium-files.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/raft-large-files.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/api/api-seen-in-wild.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/api/common_paths.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/api/actions.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/Apache.fuzz.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/frontpage.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/burp-parameter-names.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/PHP.fuzz.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 for domain in $(cat $1); do gobuster dir -u $domain -w /root/SecLists/Discovery/Web-Content/graphql.txt --wildcard | grep -e "Status: 200" >> $1.txt;done
 echo
 echo "Done with fuzzing!!"
fi
fi

if [ $l == 2 ];then
echo "Choose the way you want to fuzz: "
echo
echo "1.Custom wordlist! [Enter the wordlist path when asked!]"
echo "2.Deafult wordlist! [I had a bunch for you!]"
echo
echo "0.Fuzz with custom wordlist"
echo "1.Fuzz basic wordlist count --> 4652 "
echo "2.Fuzz medium wordlist of directories count --> 30000 "
echo "3.Fuzz large wordlist of directories count --> 62275 "
echo "4.Fuzz medium wordlist of files count --> 17128 "
echo "5.Fuzz large wordlist of files count --> 37042 "
echo "6.Fuzz api wordlist found during recon count --> 7615 "
echo "7.Fuzz api wordlist common path count --> 33 "
echo "8.Fuzz api wordlist for actions count --> 222 "
echo "9.FUzz apache basic wordlist count --> 8531 "
echo "10.Fuzz frontend wordlist count --> 43 "
echo "11.Fuzz Php wordlist count --> 104 "
echo "12.Fuzz burp-parameter-names wordlist count --> 2588 "
echo "13.Fuzz graphql wordlist count --> 12 "
echo
echo "14.Fuzz with all the above wordlists!!!"
echo "Select a wordlist to fuzz: "
read n

if [ $n == 0 ];
then
 echo "Fuzzing with custom wordlist!!"
 gobuster dir -u $1 -w $2 --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 1 ];
then
 echo "Fuzzing with basic wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/common.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 2 ];
then
 echo "Fuzzing with medium wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/raft-medium-directories.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing"
fi

if [ $n == 3 ];
then
 echo "Fuzzing with large wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/raft-large-directories.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 4 ];
then
 echo "Fuzzing with medium size files wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/raft-medium-files.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 5 ];
then
 echo "Fuzzing with large size files wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/raft-large-files.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 6 ];
then
 echo "Fuzzing with api's found during recon wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/api/api-seen-in-wild.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 7 ];
then
 echo "Fuzzing with api's common-path wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/api/common_paths.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 8 ];
then
 echo "Fuzzing with api's action wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/api/actions.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 9 ];
then
 echo "Fuzzing with apache basic wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/Apache.fuzz.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 10 ];
then
 echo "Fuzzing with frontend wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/frontpage.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 11 ];
then
 echo "Fuzzing with PHP wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/PHP.fuzz.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 12 ];
then
 echo "Fuzzing with burp-parameter-names wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/burp-parameter-names.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 13 ];
then
 echo "Fuzzing with graphql wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/graphql.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi

if [ $n == 14 ];
then
 echo "Fuzzing with all wordlist!!"
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/common.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/raft-medium-directories.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/raft-large-directories.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/raft-medium-files.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/raft-large-files.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/api/api-seen-in-wild.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/api/common_paths.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/api/actions.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/Apache.fuzz.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/frontpage.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/burp-parameter-names.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/PHP.fuzz.txt --wildcard | grep -e "Status: 200" >> $1.txt
 gobuster dir -u $1 -w /root/SecLists/Discovery/Web-Content/graphql.txt --wildcard | grep -e "Status: 200" >> $1.txt
 echo
 echo "Done with fuzzing!!"
fi
fi
}

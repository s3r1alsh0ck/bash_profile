export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

s3find(){
python3 /root/tools/S3Scanner/s3scanner.py $1
}

clean(){
reset && clear
}

hx(){
httpx -follow-redirects -status-code -title
}

get(){
echo $1 | gau | grep -v -e jpg -e png -e gif -e woff -e woff2 -e ttf -e svg -e jpeg -e css -e ico -e eot | sort -u | tee -a gau.$1.txt
}

ipinfo(){
curl http://ipinfo.io/$1 | tee -a $2
}
rshell(){
nc -l -n -vv -p 443 -k
}
hijack(){
subjack -w $1 -t 50 -v -a -o subjack.txt
}

hjc(){
subzy -target $1
}

way(){
echo $1 | waybackurls | grep -v -e jpg -e png -e gif -e woff -e woff2 -e ttf -e svg -e jpeg -e css -e ico -e eot | sort -u | tee -a wayback.$1.txt
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

b64d(){
echo $1 | base64 -d
}

b64e(){
echo $1 | base64
}

eye(){
eyewitness -f $1 --prepend-https --web
}

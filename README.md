在产品发布的时候，Android和IOS有一定的不同
IOS就只有App Store这一个渠道
而相反的Android可能有成百上千个不同的渠道(百度手机助手，豌豆荚，应用宝...)
当然我们可以在gradle脚本下通过设置productflavors
来打不同渠道的包，也非常方便
但是我们有时候除了对包进行混淆外还要进行加固
比如我们采用爱加密加固，如果本地同时打了几十个包，一一上传加固比较耗时耗力
所以通常打一个包
在加固之后分成多个渠道，然后一一下载
不过下载之后需要逐个签名，比较麻烦
今天分享一下笔者使用的脚本签名
笔者工作环境Ubutnu 14.04
使用Shell编写的简答的签名脚本，可以批量进行签名

```

#别名
aliase='temp'
#库密码
storepass='hao123'
#签名密码
keypass='hao456'
#秘钥
keystore='temp.jks'

output="output"

if [ ! -d "$output" ];then
   mkdir $output
fi

#签名
function sign(){
     jarsigner -verbose -digestalg SHA1 -sigalg MD5withRSA -tsa https://timestamp.geotrust.com/tsa -keystore $keystore -storepass $storepass -keypass $keypass -signedjar $tempname $filename $aliase 
}

function zipalign(){
     ./jre/bin/zipalign -f -v 4 $tempname $outputname
}

#$output"/"$(basename $filename .apk)"_signed.apk"
for filename in *
do 
   if [ "${filename##*.}" = "apk" ]; then
       outputname=$output"/"${filename//_unsign/_signed}
       echo "签名: "$filename
       tempname=$(basename $filename .apk)"_temp.apk"
       sign
       zipalign
       rm -rf $tempname
   fi
done

```

![这里写图片描述](http://img.blog.csdn.net/20160710145226812)


[脚本地址](https://github.com/byhook/BashSign)


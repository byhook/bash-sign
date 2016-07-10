
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




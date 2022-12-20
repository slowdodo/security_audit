# Check if they have the same UID
echo "Checking for users with the same UID..."
echo "<same_uid>" > same_uid.xml
while read user; do
  uid=$(getent passwd "$user" | awk -F: '{print $3}')
  if [ "$(awk -F: '{print $3}' /etc/passwd | grep -c "^$uid$")" -gt 1 ]; then
    echo "  <user>
    <name>$user</name>
    <uid>$uid</uid>
  </user>" >> same_uid.xml
  fi
done < <(cut -d: -f1 /etc/passwd)
echo "</same_uid>" >> same_uid.xml

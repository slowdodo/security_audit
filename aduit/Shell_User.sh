# Check if the user shell is abnormal
echo "Checking for abnormal user shells..."
echo "<abnormal_user_shells>" > abnormal_user_shells.xml
while read user; do
  shell=$(getent passwd "$user" | awk -F: '{print $7}')
  if [ "$shell" != "/bin/bash" ] && [ "$shell" != "/bin/sh" ] && [ "$shell" != "/usr/sbin/nologin" ]; then
    echo "  <user>
    <name>$user</name>
    <shell>$shell</shell>
  </user>" >> abnormal_user_shells.xml
  fi
done < <(cut -d: -f1 /etc/passwd)
echo "</abnormal_user_shells>" >> abnormal_user_shells.xml
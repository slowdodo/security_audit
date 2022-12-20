# Check if the minimum password length setting is 9 or more
echo "Checking minimum password length setting..."
echo "<password_length_setting>" > password_length_setting.xml
min_length=$(grep "^minlen" /etc/security/pwquality.conf | awk -F= '{print $2}')
if [ "$min_length" -ge 9 ]; then
  echo "  <result>
    <status>OK</status>
    <length>$min_length</length>
  </result>" >> password_length_setting.xml
else
  echo "  <result>
    <status>WARNING</status>
    <length>$min_length</length>
  </result>" >> password_length_setting.xml
fi
echo "</password_length_setting>" >> password_length_setting.xml

# Check if the minimum period of password use is more than 1 day
echo "Checking minimum period of password use..."
echo "<password_use_period>" > password_use_period.xml
min_age=$(grep "^password.*minage" /etc/pam.d/common-password | awk '{print $4}')
if [ "$min_age" -gt 1 ]; then
  echo "  <result>
    <status>OK</status>
    <period>$min_age</period>
  </result>" >> password_use_period.xml
else
  echo "  <result>
    <status>WARNING</status>
    <period>$min_age</period>
  </result>" >> password_use_period.xml
fi
echo "</password_use_period>" >> password_use_period.xml

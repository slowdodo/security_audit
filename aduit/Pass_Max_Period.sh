# Check if the maximum password period is 90 days
echo "Checking maximum password period..."
echo "<password_period>" > password_period.xml
max_age=$(grep "^password.*maxage" /etc/pam.d/common-password | awk '{print $4}')
if [ "$max_age" -eq 90 ]; then
  echo "  <result>
    <status>OK</status>
    <period>$max_age</period>
  </result>" >> password_period.xml
else
  echo "  <result>
    <status>WARNING</status>
    <period>$max_age</period>
  </result>" >> password_period.xml
fi
echo "</password_period>" >> password_period.xml
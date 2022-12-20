# Check if the account lockout threshold is correct
echo "Checking account lockout threshold..."
echo "<account_lockout_threshold>" > account_lockout_threshold.xml
threshold=$(grep "^auth.*deny" /etc/pam.d/common-auth | awk '{print $4}')
if [ "$threshold" -eq 5 ]; then
  echo "  <result>
    <status>OK</status>
    <threshold>$threshold</threshold>
  </result>" >> account_lockout_threshold.xml
else
  echo "  <result>
    <status>WARNING</status>
    <threshold>$threshold</threshold>
  </result>" >> account_lockout_threshold.xml
fi
echo "</account_lockout_threshold>" >> account_lockout_threshold.xml
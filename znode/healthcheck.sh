
ERROR=$(curl --silent $(hostname):8080/commands/ruok | jq .error)
if [ $ERROR == null ]
then
  exit 0
fi

exit 1
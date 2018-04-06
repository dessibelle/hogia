#!/bin/bash

SCRIPT_NAME=$(basename $0)
COOKIEJAR="hogia-cookie-jar.txt"

PERIOD_START=$(date -j -v-1m -v01d '+%Y-%m-%d')
PERIOD_END=$(date -j -v01d -v-1d '+%Y-%m-%d')

EVENT_ID=1

function print_usage() {
	# TODO: Load these instead
	# curl 'https://payroll.accountor.se/pbm/Json/Reports/GetSalaryEvents' \
	# -c $COOKIEJAR \
	# -b $COOKIEJAR \
	# -H 'Pragma: no-cache' \
	# -H 'Accept-Encoding: gzip, deflate, br' \
	# -H 'Accept: */*' \
	# -H 'Cache-Control: no-cache' --compressed

	echo "Usage:"
	echo -e "\t${SCRIPT_NAME} --email=<email> --password=<password> --event_id=<event_id> "
	echo -e "\t\t[--start_date=${PERIOD_START}] [--end_date=${PERIOD_END}] [--verbose]"
	echo ""
	cat <<- EOM
	event_id	description
	--------	-----------
	1 		Tidrapport klar (1)
	2 		Betald semester Tjm (510)
	3 		Sjukdom månadsavlönad Tjm (600)
	4 		Sjukdom hel månad Tjm (612)
	5 		Tjänstledighetsdagar (620)
	6 		Tjänstledig hel månad Tjm (622)
	7 		Tillf vård av barn Tjm (655)
	8 		Pappadagar (658)
	9 		Uttag av föräldradagar (660)
	10		Föräldraledig hel mån Tjm (662)
EOM
}

EVENT_ID=""
VERBOSE="-s"

while [ "$1" != "" ]; do
	PARAM=`echo $1 | awk -F= '{print $1}'`
	VALUE=`echo $1 | awk -F= '{print $2}'`
	case $PARAM in
		-h | --help)
			print_usage
			exit
			;;
		--event_id)
			EVENT_ID=$VALUE
			;;
		--email)
			EMAIL=$VALUE
			;;
		--password)
			PASSWORD=$VALUE
			;;
		--start_date)
			PERIOD_START=$VALUE
			;;
		--end_date)
			PERIOD_END=$VALUE
			;;
		--verbose)
			VERBOSE="-v"
			;;
		*)
			echo "ERROR: unknown parameter \"$PARAM\""
			usage
			exit 1
			;;
	esac
	shift
done

if [[ ! -n "$EMAIL" ]] || [[ ! -n "$PASSWORD" ]] ; then
	echo -e "Error: You need to supply email and password\n"
	print_usage
	exit 1
fi

if [[ ! -n "$EVENT_ID" ]] ; then
	echo -e "Error: No event_id supplied\n"
	print_usage
	exit 1
fi

while true; do
	echo "Setting event_id ${EVENT_ID} for ${PERIOD_START} - ${PERIOD_END}" yn
    read -p "Proceed? [y/n] " yn
    case $yn in
        [Yy] ) break;;
        [Nn] ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

curl 'https://payroll.accountor.se/BusinessManager/LogOn.aspx' \
-c $COOKIEJAR \
-b $COOKIEJAR \
-H 'Pragma: no-cache' \
-H 'Origin: https://payroll.accountor.se' \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Accept-Language: sv-SE,sv;q=0.9,en-US;q=0.8,en;q=0.7,es;q=0.6' \
-H 'Upgrade-Insecure-Requests: 1' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
-H 'Cache-Control: no-cache' \
-H 'Referer: https://payroll.accountor.se/BusinessManager/LogOn.aspx' \
-H 'Connection: keep-alive' \
--data '__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwUKLTE0MTM5MjE3NBBkZBYCZg9kFgICAw9kFgICEg9kFgICBQ9kFgJmD2QWAgIDD2QWBAIDD2QWBAIDDw8WBB4EVGV4dAUyTG9nZ2EgaW4gbWVkIGhqw6RscCBhdiBBbnbDpG5kYXJuYW1uIChBdXRvbWF0aXNrdCkeC05hdmlnYXRlVXJsBRJ%2BL1dpbkxvZ09uU3NvLmFzcHhkZAIFDw8WBB8ABSRMb2dnYSBpbiBtZWQgaGrDpGxwIGF2IEFudsOkbmRhcm5hbW4fAQUPfi9XaW5Mb2dPbi5hc3B4ZGQCBA9kFgQCAg8UKwACDxYIHhNjYWNoZWRTZWxlY3RlZFZhbHVlZB4XRW5hYmxlQWpheFNraW5SZW5kZXJpbmdoHwAFEXN2ZW5za2EgKFN2ZXJpZ2UpHgdWaXNpYmxlZ2QQFgJmAgEWAhQrAAIPFggeCEltYWdlVXJsBRR%2BL0ltYWdlcy9zdGJyaXR0LmdpZh4FVmFsdWUFBWVuLUdCHwAFGEVuZ2xpc2ggKFVuaXRlZCBLaW5nZG9tKR4IU2VsZWN0ZWRoZGQUKwACDxYIHwUFFH4vSW1hZ2VzL3N2ZXJpZ2UuZ2lmHwYFBXN2LVNFHwAFEXN2ZW5za2EgKFN2ZXJpZ2UpHwdnZGQPFgJmZhYBBXhUZWxlcmlrLldlYi5VSS5SYWRDb21ib0JveEl0ZW0sIFRlbGVyaWsuV2ViLlVJLCBWZXJzaW9uPTIwMTMuMy4xMzI0LjQwLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPTEyMWZhZTc4MTY1YmEzZDQWCGYPDxYEHghDc3NDbGFzcwUJcmNiSGVhZGVyHgRfIVNCAgJkZAIBDw8WBB8IBQlyY2JGb290ZXIfCQICZGQCAg8PFggfBQUUfi9JbWFnZXMvc3Ricml0dC5naWYfBgUFZW4tR0IfAAUYRW5nbGlzaCAoVW5pdGVkIEtpbmdkb20pHwdoZGQCAw8PFggfBQUUfi9JbWFnZXMvc3ZlcmlnZS5naWYfBgUFc3YtU0UfAAURc3ZlbnNrYSAoU3ZlcmlnZSkfB2dkZAIEDxYCHgNzcmMFFH4vSW1hZ2VzL3N2ZXJpZ2UuZ2lmZBgCBR5fX0NvbnRyb2xzUmVxdWlyZVBvc3RCYWNrS2V5X18WAQU4Y3RsMDAkQ29udGVudCRDdWx0dXJlVWlDb21ib0JveCRQcmVmZXJyZWRDdWx0dXJlQ29tYm9Cb3gFOGN0bDAwJENvbnRlbnQkQ3VsdHVyZVVpQ29tYm9Cb3gkUHJlZmVycmVkQ3VsdHVyZUNvbWJvQm94DxQrAAIFEXN2ZW5za2EgKFN2ZXJpZ2UpBQVzdi1TRWQ7RNBWQpHNuVjThsAnG9KvusqMMZySEwa9fdfRL%2BMMyg%3D%3D&__VIEWSTATEGENERATOR=10F66192&__EVENTVALIDATION=%2FwEdAAd2o6OZ5iUKIY74OHRQpPNceViOiH1ZBl%2Bh0kxNUCqqfr94ytH6qmlBN6bnPomBP2t4CTSxP6FduOznal5KGWfY0apME%2FT79k17eLoEKguu26YdP9TsYMaf9iVhATHpuAeRzSELeGyuLFr9YkEREoHNsMFldDQMcmZqDbKeqh9uLsCHXBvNUoSHLFnI0glYMpM%3D&ctl00%24Content%24UICultureName=&ctl00%24Content%24EmailField='$EMAIL'&ctl00%24Content%24PasswordField='$PASSWORD'&ctl00%24Content%24CultureUiComboBox%24UICultureName=&ctl00%24Content%24CultureUiComboBox%24PreferredCultureComboBox=svenska+%28Sverige%29&ctl00_Content_CultureUiComboBox_PreferredCultureComboBox_ClientState=&ctl00%24Buttons%24OkButton=OK' \
--compressed $VERBOSE

DATA="account=&childId=&childName=&comment=&costCentre=&costUnit=&eventId=${EVENT_ID}&extent=100&fromDate=${PERIOD_START}&fromTime=&groupRegistrationMember=&project=&quantity=&toDate=${PERIOD_END}&toTime=&toTimeCheck=&registrationId=&unitPrice=&toTimeDisabled=true"

curl 'https://payroll.accountor.se/pbm/Json/Registration/SaveDeviationRegistrations' \
-c $COOKIEJAR \
-b $COOKIEJAR \
-H 'Pragma: no-cache' \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
-H 'Accept: */*' \
-H 'Cache-Control: no-cache' \
--compressed \
--data "${DATA}" $VERBOSE

rm $COOKIEJAR

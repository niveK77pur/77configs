#!/usr/bin/env bash
if [ -z "$BASH" ] ; then
   bash  $0
   exit
fi



my_name=$0


function setup_environment {
  bf=""
  n=""
  ORGANISATION="University of Luxembourg"
  URL="your local eduroam support page"
  SUPPORT="wifi_request@uni.lu"
if [ ! -z "$DISPLAY" ] ; then
  if which zenity 1>/dev/null 2>&1 ; then
    ZENITY=`which zenity`
  elif which kdialog 1>/dev/null 2>&1 ; then
    KDIALOG=`which kdialog`
  else
    if tty > /dev/null 2>&1 ; then
      if  echo $TERM | grep -E -q "xterm|gnome-terminal|lxterminal"  ; then
        bf="[1m";
        n="[0m";
      fi
    else
      find_xterm
      if [ -n "$XT" ] ; then
        $XT -e $my_name
      fi
    fi
  fi
fi
}

function split_line {
echo $1 | awk  -F '\\\\n' 'END {  for(i=1; i <= NF; i++) print $i }'
}

function find_xterm {
terms="xterm aterm wterm lxterminal rxvt gnome-terminal konsole"
for t in $terms
do
  if which $t > /dev/null 2>&1 ; then
  XT=$t
  break
  fi
done
}


function ask {
     T="eduroam CAT"
#  if ! [ -z "$3" ] ; then
#     T="$T: $3"
#  fi
  if [ ! -z $KDIALOG ] ; then
     if $KDIALOG --yesno "${1}\n${2}?" --title "$T" ; then
       return 0
     else
       return 1
     fi
  fi
  if [ ! -z $ZENITY ] ; then
     text=`echo "${1}" | fmt -w60`
     if $ZENITY --no-wrap --question --text="${text}\n${2}?" --title="$T" 2>/dev/null ; then
       return 0
     else
       return 1
     fi
  fi

  yes=Y
  no=N
  yes1=`echo $yes | awk '{ print toupper($0) }'`
  no1=`echo $no | awk '{ print toupper($0) }'`

  if [ $3 == "0" ]; then
    def=$yes
  else
    def=$no
  fi

  echo "";
  while true
  do
  split_line "$1"
  read -p "${bf}$2 ${yes}/${no}? [${def}]:$n " answer
  if [ -z "$answer" ] ; then
    answer=${def}
  fi
  answer=`echo $answer | awk '{ print toupper($0) }'`
  case "$answer" in
    ${yes1})
       return 0
       ;;
    ${no1})
       return 1
       ;;
  esac
  done
}

function alert {
  if [ ! -z $KDIALOG ] ; then
     $KDIALOG --sorry "${1}"
     return
  fi
  if [ ! -z $ZENITY ] ; then
     $ZENITY --warning --text="$1" 2>/dev/null
     return
  fi
  echo "$1"

}

function show_info {
  if [ ! -z $KDIALOG ] ; then
     $KDIALOG --msgbox "${1}"
     return
  fi
  if [ ! -z $ZENITY ] ; then
     $ZENITY --info --width=500 --text="$1" 2>/dev/null
     return
  fi
  split_line "$1"
}

function confirm_exit {
  if [ ! -z $KDIALOG ] ; then
     if $KDIALOG --yesno "Really quit?"  ; then
     exit 1
     fi
  fi
  if [ ! -z $ZENITY ] ; then
     if $ZENITY --question --text="Really quit?" 2>/dev/null ; then
        exit 1
     fi
  fi
}



function prompt_nonempty_string {
  prompt=$2
  if [ ! -z $ZENITY ] ; then
    if [ $1 -eq 0 ] ; then
     H="--hide-text "
    fi
    if ! [ -z "$3" ] ; then
     D="--entry-text=$3"
    fi
  elif [ ! -z $KDIALOG ] ; then
    if [ $1 -eq 0 ] ; then
     H="--password"
    else
     H="--inputbox"
    fi
  fi


  out_s="";
  if [ ! -z $ZENITY ] ; then
    while [ ! "$out_s" ] ; do
      out_s=`$ZENITY --entry --width=300 $H $D --text "$prompt" 2>/dev/null`
      if [ $? -ne 0 ] ; then
        confirm_exit
      fi
    done
  elif [ ! -z $KDIALOG ] ; then
    while [ ! "$out_s" ] ; do
      out_s=`$KDIALOG $H "$prompt" "$3"`
      if [ $? -ne 0 ] ; then
        confirm_exit
      fi
    done  
  else
    while [ ! "$out_s" ] ; do
      read -p "${prompt}: " out_s
    done
  fi
  echo "$out_s";
}

function user_cred {
  PASSWORD="a"
  PASSWORD1="b"

  if ! USER_NAME=`prompt_nonempty_string 1 "enter your userid"` ; then
    exit 1
  fi

  while [ "$PASSWORD" != "$PASSWORD1" ]
  do
    if ! PASSWORD=`prompt_nonempty_string 0 "enter your password"` ; then
      exit 1
    fi
    if ! PASSWORD1=`prompt_nonempty_string 0 "repeat your password"` ; then
      exit 1
    fi
    if [ "$PASSWORD" != "$PASSWORD1" ] ; then
      alert "passwords do not match"
    fi
  done
}
setup_environment
show_info "This installer has been prepared for ${ORGANISATION}\n\nMore information and comments:\n\nEMAIL: ${SUPPORT}\nWWW: ${URL}\n\nInstaller created with software from the GEANT project."
if ! ask "This installer will only work properly if you are a member of ${bf}University of Luxembourg.${n}" "Continue" 1 ; then exit; fi
if [ -d $HOME/.cat_installer ] ; then
   if ! ask "Directory $HOME/.cat_installer exists; some of its files may be overwritten." "Continue" 1 ; then exit; fi
else
  mkdir $HOME/.cat_installer
fi
# save certificates
echo "-----BEGIN CERTIFICATE-----
MIIDGjCCAgKgAwIBAgIQSg/T1+3lFKlJdHzsMv/C9jANBgkqhkiG9w0BAQsFADAe
MRwwGgYDVQQDExN1bmktUm9vdENBLUhVRVktMjU2MB4XDTE3MDYxOTEyNTUzMVoX
DTM3MDYxOTEzMDUzMVowHjEcMBoGA1UEAxMTdW5pLVJvb3RDQS1IVUVZLTI1NjCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPb3G17UFUofWlReRdwsqFKk
4bO6k5mA26aqTPGW+sARokDZrwXXC8x4440TK7uaKGSyF6A4+IcI14x9nazgsT5A
qbJNWW0u+nrh6759caOaozZGU0XWmHmPEmWXr6SoV42+HQwb8mu1T/HGglrWgcAt
D0EdFOaXveg4BJom46Jja1hneQgI624AhW/QjutwMuURExJd78oNpgJZ57pUM1Bj
22pEcKJbFgDXp/bCVhjivD1VDGkpUcPOjKfjGcKSa4eARz97p8Fi5LOXLNpL2A6+
Q8i5zd2GLIptchYckGeG/VAs86VBWnIIDjW79VZimAA3DK+LvWWdJWEQ/gA0IDcC
AwEAAaNUMFIwCwYDVR0PBAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQEwHQYDVR0O
BBYEFND/coRlvm2AcKFxRfFHbjH4E7R1MBAGCSsGAQQBgjcVAQQDAgEAMA0GCSqG
SIb3DQEBCwUAA4IBAQDq24+Pp9xxzzaL8yv3KqjGR9B/Slg5Qsf6pwI7lRPrK5rk
t2EYSUFhoukRiW2PmgUIrX83qbQUw44LBgM06/L6u5nohXFJK3AdFHSNZoSb4B5S
9opeozo9YfPOfxshAAkfVzSL9Nlu+C/+zVDiDy+OeZAPYyBCqFU5zY3IsUHyvdk/
C3V5M/sjioNpUUKokyMloYe8z+KS0g93wg09mbf1iAbA37JoPsmGW+TrlvsaUtcr
WqLCy3qEEmKoCvPaBQDXHKdvgzgDX4ZFLOxhyGxGLlZSZuU3x45p18rcOcJDmgOP
Y0OIwRlC3eMTGnxJNdHrigRKjdjNNKUpT/1x4zQn
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIF3jCCBMagAwIBAgITRwAAAAK0gXE6+uaCVQAAAAAAAjANBgkqhkiG9w0BAQsF
ADAeMRwwGgYDVQQDExN1bmktUm9vdENBLUhVRVktMjU2MB4XDTE3MDYyMDA5MTYz
NloXDTI3MDYyMDA5MjYzNlowSDETMBEGCgmSJomT8ixkARkWA2x1eDETMBEGCgmS
JomT8ixkARkWA3VuaTEcMBoGA1UEAxMTdW5pLVN1YkNBLURFV0VZLTI1NjCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOjQcIuvvHCueOuTmExzruWANbP0
3uiQRcdhxnPkwuoA08PNsrDDQtpeTI1z83wcsSW5RGSbm65+5qIn0V0X23iGNAxy
n6xm+ENov7Nn2Rds9VGNRjPduF2NlZ87bWwia6Vp/5r5VweiKV/X1KxMmcGGQg+T
PWqg6CpUQID0jakiAVdPIDnBeFEUuoNhL6S7w+/tQcoIdvuJBgHOanDyMw1MIeJ5
lmBbzT3h9gktRrtOtkBDgzPipyMYCPb0SY6E3LJ/dRb3atsoXHjJbeosh8GAXtjZ
iNR2MaYdccQx/7jckAGKhRboFhDRBl0ikSLsahE3mzA1LTJoBoUigxdLy9MCAwEA
AaOCAukwggLlMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBSVteBj+cOOUwG1
1uaIpTHMW4JMmTAyBgNVHSAEKzApMCcGJSqGSIb3FAG+QJN6gfI9txPFc4GDeILD
TIOi/nmG8tZch2jOEBUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0P
BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHwYDVR0jBBgwFoAU0P9yhGW+bYBw
oXFF8UduMfgTtHUwggEEBgNVHR8EgfwwgfkwgfaggfOggfCGgbZsZGFwOi8vL0NO
PXVuaS1Sb290Q0EtSFVFWS0yNTYsQ049Q0EtSHVleSxDTj1DRFAsQ049UHVibGlj
JTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixE
Qz11bmksREM9bHV4P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmpl
Y3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludIY1aHR0cDovL2NybDIudW5pLmx1
L0NlcnRFbnJvbGwvdW5pLVJvb3RDQS1IVUVZLTI1Ni5jcmwwggEXBggrBgEFBQcB
AQSCAQkwggEFMIGuBggrBgEFBQcwAoaBoWxkYXA6Ly8vQ049dW5pLVJvb3RDQS1I
VUVZLTI1NixDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2Vy
dmljZXMsQ049Q29uZmlndXJhdGlvbixEQz11bmksREM9bHV4P2NBQ2VydGlmaWNh
dGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MFIGCCsG
AQUFBzAChkZodHRwOi8vY2VydDIudW5pLmx1L0NlcnRFbnJvbGwvQ0EtSHVleS51
bmkubHV4X3VuaS1Sb290Q0EtSFVFWS0yNTYuY3J0MA0GCSqGSIb3DQEBCwUAA4IB
AQAIt1KN2r9F9rwm5EMmdndQLqhZpp5KlbN0qLS0FgWeaigDtbBQX/wUFm11oiZ7
Om6tEYr1bAj2ne8q7QkAOgJzibRL/iII0rSRCStg+NOkb0vjDPO/Ba7+24ANPAxL
KPo6EfY9U8qG6MjucNmXwQJmDB6RsCR1NfOoM6rntbeWEq3c1fsGrkUPTOwZUcpC
DJKc2h+yHLE2mUKZbZ19VUzxzFgfuqXGw4eNKaHaKZgS1CC03b2LmNmjimBWAYxj
wFrwa4ZiEtIfU5pCs+rHjCkbUx3Jy5p9PWlRlzHIOCaBxrRrdzwBlou2CDLfL9zM
lpjYDf7CB23STEm+mwHoqfAl
-----END CERTIFICATE-----

" > $HOME/.cat_installer/ca.pem
function run_python_script {
PASSWORD=$( echo "$PASSWORD" | sed "s/'/\\\'/g" )
if python << EEE1 > /dev/null 2>&1
import dbus
EEE1
then
    PYTHON=python
elif python3 << EEE2 > /dev/null 2>&1
import dbus
EEE2
then
    PYTHON=python3
else
    PYTHON=none
    return 1
fi

$PYTHON << EOF > /dev/null 2>&1
#-*- coding: utf-8 -*-
import dbus
import re
import sys
import uuid
import os

class EduroamNMConfigTool:

    def connect_to_NM(self):
        #connect to DBus
        try:
            self.bus = dbus.SystemBus()
        except dbus.exceptions.DBusException:
            print("Can't connect to DBus")
            sys.exit(2)
        #main service name
        self.system_service_name = "org.freedesktop.NetworkManager"
        #check NM version
        self.check_nm_version()
        if self.nm_version == "0.9" or self.nm_version == "1.0":
            self.settings_service_name = self.system_service_name
            self.connection_interface_name = "org.freedesktop.NetworkManager.Settings.Connection"
            #settings proxy
            sysproxy = self.bus.get_object(self.settings_service_name, "/org/freedesktop/NetworkManager/Settings")
            #settings intrface
            self.settings = dbus.Interface(sysproxy, "org.freedesktop.NetworkManager.Settings")
        elif self.nm_version == "0.8":
            #self.settings_service_name = "org.freedesktop.NetworkManagerUserSettings"
            self.settings_service_name = "org.freedesktop.NetworkManager"
            self.connection_interface_name = "org.freedesktop.NetworkManagerSettings.Connection"
            #settings proxy
            sysproxy = self.bus.get_object(self.settings_service_name, "/org/freedesktop/NetworkManagerSettings")
            #settings intrface
            self.settings = dbus.Interface(sysproxy, "org.freedesktop.NetworkManagerSettings")
        else:
            print("This Network Manager version is not supported")
            sys.exit(2)

    def check_opts(self):
        self.cacert_file = '${HOME}/.cat_installer/ca.pem'
        self.pfx_file = '${HOME}/.cat_installer/user.p12'
        if not os.path.isfile(self.cacert_file):
            print("Certificate file not found, looks like a CAT error")
            sys.exit(2)

    def check_nm_version(self):
        try:
            proxy = self.bus.get_object(self.system_service_name, "/org/freedesktop/NetworkManager")
            props = dbus.Interface(proxy, "org.freedesktop.DBus.Properties")
            version = props.Get("org.freedesktop.NetworkManager", "Version")
        except dbus.exceptions.DBusException:
            version = "0.8"
        if re.match(r'^1\.', version):
            self.nm_version = "1.0"
            return
        if re.match(r'^0\.9', version):
            self.nm_version = "0.9"
            return
        if re.match(r'^0\.8', version):
            self.nm_version = "0.8"
            return
        else:
            self.nm_version = "Unknown version"
            return

    def byte_to_string(self, barray):
        return "".join([chr(x) for x in barray])


    def delete_existing_connections(self, ssid):
        "checks and deletes earlier connections"
        try:
            conns = self.settings.ListConnections()
        except dbus.exceptions.DBusException:
            print("DBus connection problem, a sudo might help")
            exit(3)
        for each in conns:
            con_proxy = self.bus.get_object(self.system_service_name, each)
            connection = dbus.Interface(con_proxy, "org.freedesktop.NetworkManager.Settings.Connection")
            try:
               connection_settings = connection.GetSettings()
               if connection_settings['connection']['type'] == '802-11-wireless':
                   conn_ssid = self.byte_to_string(connection_settings['802-11-wireless']['ssid'])
                   if conn_ssid == ssid:
                       connection.Delete()
            except dbus.exceptions.DBusException:
               pass

    def add_connection(self,ssid):
        server_alt_subject_name_list = dbus.Array({'DNS:Actarus-mgt.uni.lux','DNS:Actarus.uni.lux','DNS:Alcor-mgt.uni.lux','DNS:Alcor.uni.lux','DNS:Horos-mgt.uni.lux','DNS:Horos.uni.lu','DNS:Minos-mgt.uni.lux','DNS:Minos.uni.lux','DNS:Rigel-mgt.uni.lux','DNS:Rigel.uni.lux','DNS:Venusie-mgt.uni.lux','DNS:Venusie.uni.lux','DNS:guest.uni.lux','DNS:ise.uni.lu','DNS:sponsor.uni.lux'})
        server_name = 'uni'
        if self.nm_version == "0.9" or self.nm_version == "1.0":
             match_key = 'altsubject-matches'
             match_value = server_alt_subject_name_list
        else:
             match_key = 'subject-match'
             match_value = server_name
            
        s_con = dbus.Dictionary({
            'type': '802-11-wireless',
            'uuid': str(uuid.uuid4()),
            'permissions': ['user:$USER'],
            'id': ssid 
        })
        s_wifi = dbus.Dictionary({
            'ssid': dbus.ByteArray(ssid.encode('utf8')),
            'security': '802-11-wireless-security'
        })
        s_wsec = dbus.Dictionary({
            'key-mgmt': 'wpa-eap',
            'proto': ['rsn',],
            'pairwise': ['ccmp',],
            'group': ['ccmp', 'tkip']
        })
        s_8021x = dbus.Dictionary({
            'eap': ['peap'],
            'identity': '$USER_NAME',
            'ca-cert': dbus.ByteArray("file://{0}\0".format(self.cacert_file).encode('utf8')),
             match_key: match_value,
            'password': '$PASSWORD',
            'phase2-auth': 'mschapv2',
            'anonymous-identity': 'anonymous@uni.lu',
        })
        s_ip4 = dbus.Dictionary({'method': 'auto'})
        s_ip6 = dbus.Dictionary({'method': 'auto'})
        con = dbus.Dictionary({
            'connection': s_con,
            '802-11-wireless': s_wifi,
            '802-11-wireless-security': s_wsec,
            '802-1x': s_8021x,
            'ipv4': s_ip4,
            'ipv6': s_ip6
        })
        self.settings.AddConnection(con)

    def main(self):
        self.check_opts()
        ver = self.connect_to_NM()
        self.delete_existing_connections('eduroam')
        self.add_connection('eduroam')

if __name__ == "__main__":
    ENMCT = EduroamNMConfigTool()
    ENMCT.main()
EOF
}
function create_wpa_conf {
cat << EOFW >> $HOME/.cat_installer/cat_installer.conf

network={
  ssid="eduroam"
  key_mgmt=WPA-EAP
  pairwise=CCMP
  group=CCMP TKIP
  eap=PEAP
  ca_cert="${HOME}/.cat_installer/ca.pem"
  identity="${USER_NAME}"
  domain_suffix_match="uni"
  phase2="auth=MSCHAPV2"
  password="${PASSWORD}"
  anonymous_identity="anonymous@uni.lu"
}
EOFW
chmod 600 $HOME/.cat_installer/cat_installer.conf
}
#prompt user for credentials
  user_cred
  if run_python_script ; then
   show_info "Installation successful"
else
   show_info "Network Manager configuration failed, generating wpa_supplicant.conf"
   if ! ask "Network Manager configuration failed, but we may generate a wpa_supplicant configuration file if you wish. Be warned that your connection password will be saved in this file as clear text." "Write the file" 1 ; then exit ; fi

if [ -f $HOME/.cat_installer/cat_installer.conf ] ; then
  if ! ask "File $HOME/.cat_installer/cat_installer.conf exists; it will be overwritten." "Continue" 1 ; then confirm_exit; fi
  rm $HOME/.cat_installer/cat_installer.conf
  fi
   create_wpa_conf
   show_info "Output written to $HOME/.cat_installer/cat_installer.conf"
fi

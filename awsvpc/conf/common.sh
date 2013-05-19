# X509 Fields
KEY_SIZE=2048
KEY_EXPIRE=3650
KEY_COUNTRY="US"
KEY_PROVINCE="CA"
KEY_CITY="SanMateo"
KEY_ORG="SignalFuse"
KEY_OU="eng"
KEY_NAME="OpenVPN"

# PKCS11 fixes
PKCS11_MODULE_PATH="dummy"
PKCS11_PIN="dummy"

OPENSSL="openssl"
DIR_NAME=`dirname $0`/conf
OPEN_VPN_GATEWAY="54.244.15.5"

die()
{
    local m="$1"
    echo "$m" >&2
    echo
    usage
    exit 1
}

#
# Make sure the user provides a email address
#
check_email()
{
    if [ -z "$KEY_EMAIL" ]; then
        die "Email address must be provided."
    fi

    # Use email user name as KEY_CN
    IFS=@
    for i in $KEY_EMAIL ; do
        if [ -z "$KEY_CN" ]; then
            KEY_CN=$i
        else
            EMAIL_DOMAIN=$i
        fi
    done
    unset IFS

    if [ -z "$KEY_CN" ] || [ -z "$EMAIL_DOMAIN" ]; then
        die "You must supply a valid email address.  ($KEY_EMAIL)"
    fi
}

#
# Locate the openssl configuration file to use
#
if $OPENSSL version | grep -E "0\.9\.6[[:alnum:]]?" > /dev/null; then
    KEY_CONFIG="$DIR_NAME/openssl-0.9.6.cnf"
elif $OPENSSL version | grep -E "0\.9\.8[[:alnum:]]?" > /dev/null; then
    KEY_CONFIG="$DIR_NAME/openssl-0.9.8.cnf"
elif $OPENSSL version | grep -E "1\.0\.[[:digit:]][[:alnum:]]?" > /dev/null; then
    KEY_CONFIG="$DIR_NAME/openssl-1.0.0.cnf"
else
    KEY_CONFIG="$DIR_NAME/openssl.cnf"
fi

if ! [ -r "$KEY_CONFIG" ]; then
    die "Openssl configuration file $KEY_CONFIG could not be found."
fi

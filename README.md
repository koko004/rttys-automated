![image](https://github.com/user-attachments/assets/97ce33e1-c4ee-4689-a7c1-4cc1b0427c40)

# rttys-automated
Bash script for automated install of https://github.com/zhaojh329/rttys and https://github.com/zhaojh329/rtty/

![image](https://github.com/user-attachments/assets/fc48ee77-3add-4688-998e-e9a05d9946e4)


## Run
```
git clone https://github.com/koko004/rttys-automated
cd rttys-automated
chmod +x rttys-automated.sh
./rttys-automated.sh
```

## How to run rtty
Replace the following parameters with your own parameters

    sudo rtty -I 'My-device-ID' -h 'your-server' -p 5912 -a -v -d 'My Device Description'

If your [rttys](https://github.com/zhaojh329/rttys) is configured with mTLS enabled (device key and certificate required),
add the following parameters(Replace the following with valid paths to your own)

    -k /etc/ssl/private/abc.pem -c /etc/ssl/certs/abc.pem

You can generate them e.g. via openssl tool
    openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp521r1 -keyout /tmp/key.pem -out /tmp/cert.pem -days 18262 -nodes -subj "/C=CZ/O=Acme Inc./OU=ACME/CN=ACME-DEV-123"

If your rttys is configured with a token, add the following parameter(Replace the following token with your own)

    -t 34762d07637276694b938d23f10d7164

## Usage
Use your web browser to access your server: `http://your-server-host:5913`, then click the connection button

### connect devices with no web login required(you need to configure the device white list on the server)
http://your-server-host:5913/connect/devid1

http://your-server-host:5913/connect/devid2

### Transfer file
Transfer file from local to remote device

	rtty -R

Transfer file from remote device to the local

	rtty -S test.txt

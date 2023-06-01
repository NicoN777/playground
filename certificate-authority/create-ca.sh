# Create a CA
openssl req -new -nodes -x509 -keyout ca.key -out ca.cert -days 365 -subj "/C=US/ST=Texas/L=Austin/O=Toasty, Inc./OU=IT/CN=$(hostname)"




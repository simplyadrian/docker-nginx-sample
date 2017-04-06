#!/bin/bash
bucket=us-west-2-artifact-store
nginx_subdir=nginx
nginx_file=nginx.conf
COUNTER=0

echo "Downloading nginx configuration file..."
if [ ! -f "/tmp/${nginx_file}" ]; then
  /usr/local/bin/aws s3 cp s3://${bucket}/${nginx_subdir}/${nginx_file} /tmp/
else
  echo "${nginx_file} already exists"
fi

echo "Moving ${nginx_file}"
mv /tmp/${nginx_file} /etc/nginx/nginx.conf
while [ $? -ne 0 ] && [ $COUNTER -lt 5 ]; do
  let COUNTER=$COUNTER+1
  /usr/local/bin/aws s3 cp s3://${bucket}/${nginx_subdir}/${nginx_file} /tmp/
  echo "Moving ${nginx_file}"
  mv /tmp/${nginx_file} /etc/nginx/nginx.conf
done

nginx -g "daemon off;"

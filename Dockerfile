# source upstream docker image
FROM nginx

# update image packages and install needed packages for secret managment as well as aws cli tools
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends --no-install-suggests \
                       build-essential \
                       libffi-dev \
                       libssl-dev \
                       libyaml-dev \
                       python-pip \
                       python-dev &&\
    pip install --upgrade pip &&\
    pip install -U distribute awscli==1.11.34 credstash==1.12

# add entrypoint script to image
ADD bootstrap.sh .

# add executable bits to entrypoint script
RUN chmod +x bootstrap.sh

# define entrypoint
ENTRYPOINT ["./bootstrap.sh"]

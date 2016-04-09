# Original code from https://github.com/gituser173/docker-scp-server
# This image is designed to collaborate with the Docker Hub image httpd:2.4
FROM debian:jessie

ENV HTTPD_PREFIX /usr/local/apache2
ENV DATADIR $HTTPD_PREFIX/htdocs
ENV AUTHORIZED_KEYS_FILE /authorized_keys
ENV OWNER www
RUN apt-get update \
 && apt-get install -y openssh-server rssh \
 && rm -f /etc/ssh/ssh_host_* \
 && useradd --non-unique --uid 33 --gid 33 --no-create-home --home-dir /usr/local/apache2/htdocs --shell /usr/bin/rssh $OWNER \
 && mkdir -p "$DATADIR" \
 && chown $OWNER "$DATADIR" \
 && echo "AuthorizedKeysFile $AUTHORIZED_KEYS_FILE" >>/etc/ssh/sshd_config \
 && echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1" >>/etc/ssh/sshd_config \
 && touch $AUTHORIZED_KEYS_FILE \
 && chown $OWNER $AUTHORIZED_KEYS_FILE \
 && chmod 0600 $AUTHORIZED_KEYS_FILE \
 && mkdir /var/run/sshd && chmod 0755 /var/run/sshd \
 && echo "allowscp" >> /etc/rssh.conf \
 && echo "allowsftp" >> /etc/rssh.conf

ADD entrypoint.sh /

EXPOSE 22

CMD ["/entrypoint.sh"]

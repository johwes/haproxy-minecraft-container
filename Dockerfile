from registry.access.redhat.com/ubi8
RUN INSTALL_PKGS="haproxy procps-ng util-linux" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all && \
    mkdir -p /var/lib/haproxy/conf && \
    setcap 'cap_net_bind_service=ep' /usr/sbin/haproxy && \
    chown -R 1001:1001 /var/lib/haproxy && \
    chmod -R +w /var/lib/haproxy
    
USER 1001
COPY haproxy.cfg /var/lib/haproxy/conf/
EXPOSE 80 443
WORKDIR /var/lib/haproxy/conf
COPY start.sh /
ENTRYPOINT ["/start.sh"]
CMD ["haproxy", "-f", "/var/lib/haproxy/conf//haproxy.cfg"]

FROM registry.redhat.io/rhel8/python-38:1-104

LABEL io.k8s.display-name="JupyterHub" \
      io.k8s.description="JupyterHub." \
      io.openshift.tags="builder,python,jupyterhub" \
      io.openshift.s2i.scripts-url="image:///opt/app-root/builder"

USER root

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src && \
    mv /tmp/src/.s2i/bin /tmp/scripts

RUN yum install -y nss && \
    yum clean all && \
    rm -rf /var/cache/yum

USER 1001

ENV NPM_CONFIG_PREFIX=/opt/app-root \
    PYTHONPATH=/opt/app-root/src

RUN /tmp/scripts/assemble

CMD [ "/opt/app-root/builder/run" ]

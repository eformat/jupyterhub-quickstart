FROM centos/python-36-centos7:latest

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

USER 1001

ENV NPM_CONFIG_PREFIX=/opt/app-root \
    PYTHONPATH=/opt/app-root/src

RUN /tmp/scripts/assemble

# postgres client
ADD postgresql-jdbc-42.3.6-1.rhel8.noarch.rpm /tmp
RUN yum install /tmp/postgresql-jdbc-42.3.6-1.rhel8.noarch.rpm postgresql-devel && \
    yum clean all && \
    rm -rf /var/cache/yum

CMD [ "/opt/app-root/builder/run" ]

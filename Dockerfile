# This first image is just used to download the MariaDBdriver 
FROM ubuntu as base
# We build using stages because we dont need the wget in the final image
RUN apt-get update \   
    && apt-get install --no-install-recommends -y \
    default-jdk \
    git \  
    maven \ 
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/gbalboa-git/tomcat-security-utils.git \
    && mvn -f tomcat-security-utils/pom.xml package \
    && wget "https://downloads.mariadb.com/Connectors/java/connector-java-2.7.1/mariadb-java-client-2.7.1.jar"

FROM gbalboa72/tomcat-apr:latest

LABEL maintainer="Gustavo Balboa <gbalboa@hotmail.com>" \
    name="Tomcat-APR-MariaDB" \
    description="Tomcat-APR with user authentication from Maria DB Database" \
    version="1.0"

ENV DB_HOST=dbhost
ENV DB_PORT=3306
ENV DB_NAME=maindb
ENV DB_USR_NAME=webappusr
ENV DB_USR_PASS=39c708c8ed0c86cde079333a358e70092b560b62697febfc6acb6d804e3001bcf6765fe6600747ac935f3fa41d9667e73e2d4354e6fbbab9dd1a6ed7fbb382ca
ENV DB_USR_TABLE=CatUserAccounts
ENV DB_USR_NAMEFIELD=LoginName
ENV DB_USR_PASSFIELD=PwdHash
ENV DB_USR_ROLE_TABLE=UserRoles
ENV DB_ROLE_FIELDNAME=RoleId

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

# copy from base the downloaded MariaDB driver and put in Tomcat lib directory
COPY --from=base mariadb-java-client-2.7.1.jar tomcat-security-utils/target/tomcat-security-utils-1.0.jar ${CATALINA_HOME}/lib/

COPY confs/ ${CATALINA_HOME}/

WORKDIR ${CATALINA_HOME}

# The tomcat-users* files are no longer needed
# The catalina-opts.sh will add the MariaDB info to the CATALINA_OPTS file (thos env vars will be loaded by the default entry point)
RUN ./catalina-opts.sh \        
    && rm -f catalina-opts.sh \
    rm -f ./conf/tomcat-users.* 



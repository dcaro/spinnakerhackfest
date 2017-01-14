import hudson.model.JDK
import hudson.tools.JDKInstaller
import hudson.tools.InstallSourceProperty
import jenkins.model.*
import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;


def descriptor = new JDK.DescriptorImpl();

// Add github credentials to Jenkins domains
println 'create github user credentials'
Credentials c = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,"github_user", "description", "user", "password")
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), c)

// Add Orcale user credentials for JDK
// Credentials c = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,"github user", "description", "user", "password")
// SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.JDK(), c)

// Add the JDK installation  
if (descriptor.getInstallations()) {
    println 'skip jdk installations'
} else {
    println 'add jdk8'
    Jenkins.instance.updateCenter.getById('default').updateDirectlyNow(true)
    def jdkInstaller = new JDKInstaller('jdk-8u112-oth-JPR', true)
    def jdk = new JDK("jdk8", null, [new InstallSourceProperty([jdkInstaller])])
    descriptor.setInstallations(jdk)
}

// Add the Gradle configuration

// Create the pipeline
// To be done with Jenkins CLI 
//  java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://user:password@localhost:8080 get-job "Build Hello World" > jenkins_job.xml


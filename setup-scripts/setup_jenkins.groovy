import hudson.model.JDK
import hudson.tools.JDKInstaller
import hudson.tools.InstallSourceProperty
import jenkins.model.*
import hudson.model.*
import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

import hudson.tasks.Gradle

def descriptor = new JDK.DescriptorImpl();
def OracleUser = args[0];
def OraclePwd = args[1];
def GitHubUser = args[2];
def GitHubPwd = args[3];

// Add github credentials to Jenkins domains
println 'create github user credentials'
Credentials c = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,"github_user", "GitHub user", GitHubUser, GitHubPwd)
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), c)

// Add Orcale user credentials for JDK
def inst = Jenkins.getInstance()
def desc = inst.getDescriptor("hudson.tools.JDKInstaller")
println desc.doPostCredential(OracleUser,OraclePwd)

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
// def gradle = new Gradle.GradleInstallation('gradle_3.3', null, [new InstallSourceProperty([new Gradle.GradleInstaller('3.3')])])


// Create the pipeline
// To be done with Jenkins CLI 
//  java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://user:password@localhost:8080 get-job "Build Hello World" > jenkins_job.xml

// java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://jenkins:Passw0rd@localhost:8080 groovy setup_jenkins.groovy
// java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://jenkins:Passw0rd@localhost:8080 create-job MyJob < jenkins_job.xml

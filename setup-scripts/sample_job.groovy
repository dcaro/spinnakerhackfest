import hudson.model.*
import jenkins.model.*

import hudson.plugins.git.GitSCM
import hudson.plugins.copyartifact.CopyArtifact
import hudson.triggers.SCMTrigger
import hudson.tasks.Shell;

def GitHubRepo = "https://github.com/rguthriemsft/hello-karyon-rxnetty/"
def GitHubUser = args[0];
def GitHubPwd = args[1];

def ShellBuildStep1 = """rm -f propertyfile.txt
cat <<EOT >> propertyfile.txt
version: 1
BRANCH_NAME: \$BRANCH_NAME
CHANGE_ID: \$CHANGE_ID
CHANGE_URL: \$CHANGE_URL
CHANGE_TITLE \$CHANGE_TITLE
CHANGE_AUTHOR: \$CHANGE_AUTHOR
CHANGE_AUTHOR_DISPLAY_NAME: \$CHANGE_AUTHOR_DISPLAY_NAME
CHANGE_AUTHOR_EMAIL: \$CHANGE_AUTHOR_EMAIL
CHANGE_TARGET: \$CHANGE_TARGET
BUILD_NUMBER: \$BUILD_NUMBER
BUILD_ID: \$BUILD_ID
BUILD_DISPLAY_NAME: \$BUILD_DISPLAY_NAME
JOB_NAME: \$JOB_NAME
JOB_BASE_NAME: \$JOB_BASE_NAME
BUILD_TAG: \$BUILD_TAG
EXECUTOR_NUMBER: \$EXECUTOR_NUMBER
NODE_NAME: \$NODE_NAME
NODE_LABELS: \$NODE_LABELS
WORKSPACE: \$WORKSPACE
JENKINS_HOME: \$JENKINS_HOME
JENKINS_URL: \$JENKINS_URL
BUILD_URL: \$BUILD_URL
JOB_URL: \$JOB_URL
SVN_REVISION: \$SVN_REVISION
SVN_URL: \$SVN_URL
EOT

./gradlew clean packDeb"""

def ShellBuildStep2 = """/opt/aptly/aptly repo add -force-replace hello build/distributions/*.deb /opt/aptly/aptly publish update -force-overwrite -architectures="amd64" -skip-signing=true trusty
"""

// Add github credentials to Jenkins domains
println 'create github user credentials'
Credentials c = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,"github_user", "GitHub user", GitHubUser, GitHubPwd)
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), c)

// Create as sample workflow
println 'create workflow'
job = Jenkins.instance.createProject(FreeStyleProject, 'hello_world')
job.displayName = 'Build Hello World'
job.scm = new GitSCM(GitHubRepo)
job.scm.userRemoteConfigs[0].credentialsId = "github_user"
job.addTrigger(new SCMTrigger("* * * * *"))
job.buildersList.add(new Shell(ShellBuildStep1))
job.buildersList.add(new Shell(ShellBuildStep2))
//job.publishersList.add(new hudson.plugins.copyartifact.CopyArtifact(archivefile))
job.save()

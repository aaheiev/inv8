#!/usr/bin/env groovy

import groovy.json.*

def imagePullSecret   = "ngsnonprodregkey"
def tlsSecret         = "fdr.pitneycloud-tls"
def containerRegistry = "ngsnonprod.azurecr.io"
def appEnvType        = "nonprod"
def appEnv            = ["dev", "qa", "stg"]
def jsonUrl           = "https://bitbucket.org/!api/2.0/snippets/ngsteam/nej5kE/8e7b96a6c830f6eb6b22ea50d36cd9ec98c2be1f/files/erdd-deploy-mm-form.json".toURL()
def jsonFormUrl       = "https://bitbucket.org/!api/2.0/snippets/ngsteam/oed5qX/d71b0d248e254a67caa2b2591ffe9c6cd33dbfda/files/dockerImageForm_partial.json".toURL()
def jsonEditorOptions = new JsonSlurper().parse(jsonUrl)

def applications = [
    [ title: "EDD-IND", name: "ngs-edd-ind-model" ],
    [ title: "EDD-SHP", name: "ngs-edd-shp-model" ],
    [ title: "ERD-SHP", name: "ngs-erd-shp-model" ]
]
// config
jsonEditorOptions["schema"]["properties"]["app_env_type"]["default"] = appEnvType
jsonEditorOptions["schema"]["properties"]["app_env"]["enum"] = appEnv
jsonEditorOptions["schema"]["properties"]["app_env"]["default"] = appEnv[0]
jsonEditorOptions["schema"]["properties"]["k8s_settings"]["properties"]["image_pull_secret"]["default"] = imagePullSecret
jsonEditorOptions["schema"]["properties"]["k8s_settings"]["properties"]["tls_secret"]["default"] = tlsSecret
jsonEditorOptions["schema"]["properties"]["k8s_settings"]["properties"]["container_registry"]["default"] = containerRegistry

// for list of docker images
jsonEditorOptions["schema"]["properties"]["docker_image"]["oneOf"] = []

applications.each { app ->
    def tags = sortTagList(getDockerImageTags("${containerRegistry}/${app["name"]}"))
    if (tags){
        def dockerImageForm = new JsonSlurper().parse(jsonFormUrl)
        dockerImageForm["title"]                          = app["title"]
        dockerImageForm["properties"]["name"]["template"] = app["name"]
        dockerImageForm["properties"]["tag"]["enum"]      = tags
        dockerImageForm["properties"]["tag"]["default"]   = tags[0]
        jsonEditorOptions["schema"]["properties"]["docker_image"]["oneOf"] << dockerImageForm
    }
}

return jsonEditorOptions

def getDockerImageTags(dockerImagePath = 'ngsnonprod.azurecr.io/ngs-edd-ind-model'){
    def dockerImagePathParts = dockerImagePath.split('/')
    def dockerImageName      = dockerImagePathParts[1]
    def containerRegistry    = dockerImagePathParts[0].split("\\.")[0]
    def apiUrl               = "https://${containerRegistry}.azurecr.io/v2/${dockerImageName}/tags/list".toURL()
    def basicAuth            = ""
    com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl.class).each{ c ->
        if (c.id == containerRegistry){
            basicAuth = "Basic " + javax.xml.bind.DatatypeConverter.printBase64Binary("${c.username}:${c.password.getPlainText()}".getBytes());
        }
    }
    try {
        def httpConnection = apiUrl.openConnection();
        httpConnection.setRequestProperty("Authorization",basicAuth);
        def inputStream = httpConnection.getInputStream();
        def azRepoTags = new groovy.json.JsonSlurper().parseText(inputStream.text);
        httpConnection.disconnect();
        return azRepoTags['tags']
    } catch (all) {
        return []
    }
}

def sortTagList(List listToSort) {
    def retList = listToSort.sort(false) {x, y ->
        def xa = x.tokenize('.'); def ya = y.tokenize('.')
        def sz = Math.min(xa.size(), ya.size())
        for (int i = 0; i < sz; i++) {
            def xs = xa[i]; def ys = ya[i];
            if (xs.isInteger() && ys.isInteger()) {
                def xn = xs.toInteger()
                def yn = ys.toInteger()
                if (xn != yn) { return xn <=> yn }
            }
        }
        return xa.size() <=> ya.size()
    }
//    retList.remove("latest")
//    retList << "latest"
    return retList.reverse()
}

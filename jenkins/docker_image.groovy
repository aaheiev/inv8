#!/usr/bin/env groovy

import groovy.json.*
import org.boon.Boon;

//def apiUrl = "http://192.168.117.113:8888/models_form/edd/ind".toURL()
//def apiUrl = "https://ptn-inv8.fdr.pitneycloud.com/models_form/edd/ind".toURL()
//def jsonEditorOptions = new JsonSlurper().parse(apiUrl)

def jsonEditorTemplate = """
{
  "disable_array_add"             : false,
  "disable_array_delete"          : false,
  "disable_array_repropertyOrder" : true,
  "disable_collapse"              : true,
  "disable_edit_json"             : true,
  "disable_properties"            : true,
  "theme"                         : "bootstrap3",
  "iconlib"                       : "fontawesome4",
  "no_additional_properties"      : true,
  "schema"                        : {
    "title"                       : "Docker image",
    "type"                        : "object",
    "format"                      : "grid",
    "properties"                  : {
      "docker_image_name"         : {
        "propertyOrder"           : 1,
        "type"                    : "string",
        "readOnly"                : "true",
        "template"                : "ngs-edd-ind-model"
      },
      "docker_image_tag"          : {
        "propertyOrder"           : 2,
        "type"                    : "string",
        "format"                  : "select",
        "uniqueItems"             : true,
        "enum"                    : ["1.6.0.28", "1.6.0.27", "1.6.0.25"],
        "default"                 : "1.6.0.28"
      }
    }
  }
}
"""
def inputFile = new File("/devops/docker_image.json")

def jsonEditorOptions = new JsonSlurper().parseText(jsonEditorTemplate)

def tags = sortTagList(getDockerImageTags('ngsnonprod.azurecr.io/ngs-edd-ind-model'))

jsonEditorOptions['schema']['properties']['docker_image_name']['template'] = 'ngs-edd-ind-model'
jsonEditorOptions['schema']['properties']['docker_image_tag']['enum'] = tags
jsonEditorOptions['schema']['properties']['docker_image_tag']['default'] = tags[0]

//println new JsonBuilder( jsonEditorOptions ).toPrettyString()
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
    def httpConnection = apiUrl.openConnection();
    httpConnection.setRequestProperty("Authorization",basicAuth);
    def inputStream = httpConnection.getInputStream();
    def azRepoTags = new groovy.json.JsonSlurper().parseText(inputStream.text);
    httpConnection.disconnect();
    return azRepoTags['tags']
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

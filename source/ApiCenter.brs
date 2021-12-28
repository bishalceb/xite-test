function HomeApi(path)
    params={}
    requestHandlerObject = getServerObject1()
    urlPath=path
    objectParam  = {
                "uri"           : urlPath,
                "requestType"   : "GET",
    }
    startTaskNode(requestHandlerObject,objectParam)
    requestHandlerObject.ObserveField("content","getNewHomeApiCallback")
end function

function getNewHomeApiCallback(response as object)
    taskNode = response.getRoSGNode()
    if taskNode <> invalid then
        responseCode  = taskNode.responseCode
        if responseCode = 200 then
          homeJson = ParseJson(taskNode.content)
          ? "home json=="homeJson
          m.top.contentNode=homeJson
        else if responseCode > 400 then
            resJson = parseJson(taskNode.content)
            if resJson <> invalid then
                if resJson.message <> invalid then
                    message = resJson.message
                end if
            else
                message = taskNode.reason
            end if
            showErrorDialog("Network Error",message)
        else if responseCode < 0 then
              resJson = parseJson(taskNode.content)
              ? "resJson "resJson
              if resJson <> invalid then
                  if resJson.errormessage <> invalid then
                      message = resJson.errormessage
                  end if
              end if
              showErrorDialog("Network Error",message)
        end if
    end if
end function




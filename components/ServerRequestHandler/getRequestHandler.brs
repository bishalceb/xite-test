sub init()
	m.port = createObject("roMessagePort")
	m.top.functionName="getDataFromServer"
end sub

function getDataFromServer()
	requestObject = createUrlObject( m.top.uri)
	requestObject.setMessagePort(m.port)
	requestObject.SetRequest(m.top.requestType)

	if m.top.contentType = "json"
		requestObject.AddHeader("Content-Type", "application/json")
	else
		requestObject.AddHeader("Content-Type", "application/x-www-form-urlencoded")
	end if

	if 	len(m.top.authKey) > 0 then
		requestObject.AddHeader("x-americonic-key", ParseJson(m.top.authKey))
	end if
    if 	len(m.top.token) > 0 then
		requestObject.AddHeader("x-americonic-user-token", ParseJson(m.top.token))
	end if

    ' if 	len(m.top.deviceId) > 0 then
    '     ''?"device id"m.top.deviceId
	' 	requestObject.AddHeader("device-id", m.top.deviceId)
	' end if

	if (UCase(m.top.requestType)=UCase("GET")) then
			urlResponse = requestObject.AsyncGetToString()
	else
			requestObject.RetainBodyOnError(true)
			urlResponse = requestObject.AsyncPostFromString(m.top.param)
	end if
	processReqest(urlResponse)
end function

function processReqest(urlResponse)

	if(urlResponse = true)
           while true
                msg = wait(30000, m.port)
                messageType = type(msg)
                if messageType <> "roUrlEvent" OR (messageType = "roUrlEvent" AND msg.GetResponseCode() < 0)
                            print "Task base Network timeout"
                            networkError = {}
                            networkError.errorCode = -1
                            networkError.errorMessage = "Network Timeout"
                            m.top.responseCode = -1
                            m.top.content = FormatJson(networkError,1)
                            dismissProgressDialog()
                            exit while
                 else if messageType = "roUrlEvent"
                            m.top.responseCode = msg.getResponseCode()
                            header = msg.GetResponseHeaders()
                            apiName = CreateObject("roString")
                            apiName.setString("login")
                            reason = msg.GetFailureReason()
                            m.top.reason = reason
                            ? "reason : "reason;" | m.top.responseCode : "m.top.responseCode;
                            if m.top.responseCode=200
                                m.top.content = msg.Getstring()
                            else                                    
                                networkError = {}
                                networkError.errorCode = m.top.responseCode
                                networkError.errorMessage = "500 error"
                                m.top.content = FormatJson(networkError,1)
                            end if
                            exit while
                 end if
           end while
     end if
end function


function createUrlObject( path as string) as dynamic
    urlObject = invalid
    urlObject = CreateObject("roUrlTransfer")
		apiBaseUrl =getBaseUrl()
		if m.top.islogin=true
		  urlString = path
		else
		  urlString = apiBaseUrl + path
		end if
		
		print "Create URL object for ==>"; urlString
		urlObject.SetUrl(urlString)

        useSecureConnection  = secureConnectionUsed(urlString)

    if useSecureConnection = true
        urlObject.SetCertificatesFile("common:/certs/ca-bundle.crt")
        urlObject.AddHeader("X-Roku-Reserved-Dev-Id", "")
        urlObject.InitClientCertificates()
    end if

    return urlObject
end function

function secureConnectionUsed(urlString as String) as Boolean
    secureConnection = false
    urlStringTokens = []

    urlStringObj = CreateObject("roString")
    urlStringObj.SetString(urlString)

    urlStringTokens = urlStringObj.Tokenize("://")

    if urlStringTokens.Count() > 0
        if urlStringTokens[0] = "https"
            secureConnection = true
        end if
    end if

    return secureConnection
end function
